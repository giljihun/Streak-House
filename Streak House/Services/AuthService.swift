//
//  AuthService.swift
//  Streak House
//
//  Created by 길지훈 on 4/17/25.
//
import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class AuthService: NSObject {
    // 현재 인증된 사용자 가져오기
    func getCurrentUser() -> User? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return User(user: firebaseUser)
    }
    
    // 로그아웃
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Apple 로그인 처리를 위한 nonce 저장
    private var currentNonce: String?
    
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
    
    // Apple 로그인 요청 생성
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        return request
    }
    
    // Firebase로 Apple 인증 처리
    func handleAppleSignIn(with authorization: ASAuthorization) async throws -> User {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let nonce = currentNonce else {
            throw NSError(domain: "AuthService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Apple 로그인 요청이 올바르지 않습니다."])
        }
        
        guard let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw NSError(domain: "AuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "ID 토큰을 가져올 수 없습니다."])
        }
        
        // Firebase 인증 정보 생성 (공식 문서 기반으로 수정)
        let credential = OAuthProvider.appleCredential(
            withIDToken: idTokenString,
            rawNonce: nonce,
            fullName: appleIDCredential.fullName
        )
        
        // Firebase 로그인 시도
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            return User(user: authResult.user)
        } catch {
            throw error
        }
    }
    
    // 계정 삭제
    func deleteAccount(authorizationCode: String) async throws {
        // 토큰 취소
        try await Auth.auth().revokeToken(withAuthorizationCode: authorizationCode)
        
        // 현재 사용자 삭제
        try await Auth.auth().currentUser?.delete()
    }
}
