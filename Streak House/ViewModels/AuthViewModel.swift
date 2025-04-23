//
//  AuthViewModel.swift
//  Streak House
//
//  Created by 길지훈 on 4/17/25.
//
// AuthViewModel: 로그인 흐름 관리 및 UI 상태 처리
// AuthService: Firebase 인증 관련 API 호출 담당

/*
 [🔥 AuthViewModel.swift - 파이어베이스 연동 흐름 요약]

 1. Apple 로그인 시작 → startSignInWithAppleFlow()
 2. Apple 로그인 성공 후 Firebase 로그인 및 사용자 Firestore에 저장
 3. 사용자 관심사 선택 시 Firestore에 업데이트 → saveUserInterests(_:)
 */

import Foundation
import SwiftUI
import AuthenticationServices
import FirebaseAuth
import CryptoKit
import FirebaseFirestore

@MainActor
class AuthViewModel: NSObject, ObservableObject,Sendable {
    enum AuthMode {
        case login
        case delete
    }

    private var authMode: AuthMode = .login

    @Published var currentUser: FirestoreUser?
    @Published var isAuthenticated = false
    @Published var error: Error?
    @Published var isLoading = false
    @Published var didSelectInterests: Bool = false
    
    private let authService = AuthService()
    
    // Apple 로그인 처리를 위한 nonce 저장
    private var currentNonce: String?
    
    override init() {
        super.init()
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        if let firebaseUser = Auth.auth().currentUser {
            let uid = firebaseUser.uid
            Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
                if let document = snapshot, document.exists {
                    do {
                        let user = try document.data(as: FirestoreUser.self)
                        self.currentUser = user
                        self.isAuthenticated = true
                    } catch {
                        print("❌ FirestoreUser decoding error: \(error)")
                        self.isAuthenticated = false
                    }
                } else {
                    print("❌ No Firestore user document found.")
                    self.isAuthenticated = false
                }
            }
        } else {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }
    
    // 로그아웃
    func signOut() {
        isLoading = true
        do {
            try authService.signOut()
            self.currentUser = nil
            self.isAuthenticated = false
            // self.didSelectInterests = false
            self.isLoading = false
        } catch {
            self.error = error
            self.isLoading = false
        }
    }
    
    // 랜덤 nonce 생성
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }

        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }

        return String(nonce)
    }
    
    // SHA256 해시 생성
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()

        return hashString
    }
    
    func prepareAppleSignIn() -> String {
        authMode = .login
        let nonce = randomNonceString()
        currentNonce = nonce
        return sha256(nonce)
    }
    
    // Apple 로그인 시작
    func startSignInWithAppleFlow() {
        authMode = .login
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // 계정 삭제
    func deleteAccount() {
        authMode = .delete
        // Apple 로그인을 통해 인증 코드를 다시 가져와야 함
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
}

// MARK: - ASAuthorizationControllerDelegate
extension AuthViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        isLoading = true
        
        // 계정 삭제 모드인 경우
        if authMode == .delete {
            handleAccountDeletion(authorization: authorization)
            return
        }
        
        // 로그인 처리
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce else {
            self.error = NSError(domain: "AuthViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "Apple 로그인 요청이 올바르지 않습니다."])
            self.isLoading = false
            return
        }
        
        guard let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            self.error = NSError(domain: "AuthViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "ID 토큰을 가져올 수 없습니다."])
            self.isLoading = false
            return
        }
        
        // Firebase 인증 정보 생성 (공식 문서와 일치하는 방식)
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        // Firebase 로그인 시도
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error
                    self.isLoading = false
                    return
                }
                
                if let user = authResult?.user {
                    // 사용자 이름이 없거나 비어있거나 "unknown"인 경우 이메일 기반으로 설정
                    if user.displayName == nil || user.displayName?.isEmpty == true || user.displayName == "unknown" {
                        // 이메일에서 사용자 이름 추출
                        self.updateUserDisplayNameWithEmail(user: user)
                    } else {
                        let uid = user.uid
                        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
                            if let snapshot = snapshot, snapshot.exists {
                                do {
                                    let user = try snapshot.data(as: FirestoreUser.self)
                                    self.currentUser = user
                                    self.isAuthenticated = true
                                } catch {
                                    print("❌ FirestoreUser decoding error: \(error)")
                                    self.isAuthenticated = false
                                }
                            } else {
                                print("❌ No Firestore user document found.")
                                self.isAuthenticated = false
                            }
                            self.isLoading = false
                        }
                    }
                } else {
                    self.isLoading = false
                }
            }
        }
    }
    
    // 이메일 기반으로 사용자 이름 업데이트
    private func updateUserDisplayNameWithEmail(user: FirebaseAuth.User) {
        let changeRequest = user.createProfileChangeRequest()
        
        // 이메일에서 사용자 이름 추출 (@ 앞부분)
        let emailUsername = user.email?.components(separatedBy: "@").first
        let username = emailUsername ?? "User\(String(user.uid.prefix(5)))"
        
        print("사용자 이메일: \(user.email ?? "없음")")
        print("생성된 사용자 이름: \(username)")
        
        changeRequest.displayName = username
        
        changeRequest.commitChanges { [weak self] error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error
                    self.isLoading = false
                    return
                }
                
                // 이름 업데이트 후 사용자 정보 갱신
                let uid = user.uid
                let firestoreUser = FirestoreUser(
                    id: uid,
                    email: user.email ?? "",
                    displayName: username,
                    photoURL: user.photoURL?.absoluteString
                )
                self.currentUser = firestoreUser
                self.isAuthenticated = true
                self.isLoading = false
                
                let db = Firestore.firestore()
                let docRef = db.collection("users").document(user.uid)

                docRef.getDocument { snapshot, error in
                    if let snapshot = snapshot, snapshot.exists {
                        print("✅ Firestore: 사용자 확인! - \(user.uid)")
                    } else {
                        do {
                            try docRef.setData(from: firestoreUser)
                            print("✅ Firestore: 사용자 정보 저장 성공")
                        } catch {
                            print("❌ Firestore: 사용자 저장 실패 - \(error)")
                        }
                    }
                }
            }
        }
    }
    
    /* MARK: - 애플 로그인은 최초 로그인 1회에만 사용자 fullName을 제공한다.
        하지만 무슨 이유인지.. 가져오지 못하네..
        근데 생각해보니 사용자 이름을 닉네임으로 하는거보단 이메일 앞부분 하는게 좋을듯.
     */
    private func updateUserDisplayName(user: FirebaseAuth.User, fullName: PersonNameComponents) {
        // 이 메서드는 더 이상 사용하지 않지만 호환성을 위해 유지
        updateUserDisplayNameWithEmail(user: user)
    }
    
    private func handleAccountDeletion(authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCode = appleIDCredential.authorizationCode,
              let authCodeString = String(data: authorizationCode, encoding: .utf8) else {
            self.error = NSError(domain: "AuthViewModel", code: 0, userInfo: [NSLocalizedDescriptionKey: "인증 코드를 가져올 수 없습니다."])
            self.isLoading = false
            return
        }
        
        // 현재 사용자가 있는지 명시적으로 확인
        guard let currentUser = Auth.auth().currentUser else {
            self.error = NSError(domain: "AuthViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "현재 로그인된 사용자가 없습니다."])
            self.isLoading = false
            return
        }
        
        // 재인증 먼저 수행
        guard let nonce = currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            self.error = NSError(domain: "AuthViewModel", code: 2, userInfo: [NSLocalizedDescriptionKey: "인증 토큰을 가져올 수 없습니다."])
            self.isLoading = false
            return
        }
        
        // 재인증용 credential 생성
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: nil
        )
        
        // 재인증 후 계정 삭제
        currentUser.reauthenticate(with: credential) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
                return
            }
            
            // 재인증 성공 후 토큰 취소 및 계정 삭제
            Task {
                do {
                    // 토큰 취소
                    try await Auth.auth().revokeToken(withAuthorizationCode: authCodeString)
                    
                    // 계정 삭제
                    try await Auth.auth().currentUser?.delete()
                    
                    // Firestore 사용자 문서 삭제
                    let uid = currentUser.uid
                    Firestore.firestore().collection("users").document(uid).delete { error in
                        if let error = error {
                            print("❌ Firestore 사용자 문서 삭제 실패: \(error.localizedDescription)")
                        } else {
                            print("✅ Firestore 사용자 문서 삭제 완료")
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.currentUser = nil
                        self.isAuthenticated = false
                        self.didSelectInterests = false
                        self.isLoading = false
                    }
                } catch {
                    DispatchQueue.main.async {
                        print("계정 삭제 오류: \(error.localizedDescription)")
                        self.error = error
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        DispatchQueue.main.async {
            self.error = error
            self.isLoading = false
        }
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension AuthViewModel: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // 현재 활성화된 윈도우를 반환
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
