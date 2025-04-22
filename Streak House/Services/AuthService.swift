//
//  AuthService.swift
//  Streak House
//
//  Created by 길지훈 on 4/17/25.
//
// AuthService: Firebase 인증 관련 API 호출 담당


/* MARK: - Sign in with apple 로직 정리
 
### 로그인 초기화

1. 보안을 위한 **nonce**(유일성 보장의 키라고 함) 생성 및 저장
2.  **nonce**를 포함하여 Apple 로그인 Request -> 이름, 이메일 권한 요청
3. 로그인 시트 표시

### 로그인 완료 처리

1. Apple에서 반환된 인증 정보 -> 데이터 추출
2. Firebase용 인증 정보 생성
3. Firebase 인증 시스템으로 로그인 시도
4. 기타 작업..(사용자 정보를 통해 앱 내 사용하거나..)
5. 앱의 인증 상태 업데이트(isAuthenticated = false)

### 로그아웃

1. 현재 사용자 상태 초기화 (currentUser = nil)
2. 앱의 인증 상태 업데이트(isAuthenticated = true)

### 계정 삭제

1. 로그인 할 때랑 같은 방식으로 Apple 인증 시작(애플 정책이라고함)
2. Apple에서 반환된 인증 코드를 추출.
3. Firebase에 등록되어있으니, Firebase에 해당 코드로 인증을 함.
4. Firebase에서 토큰 취소(revokeToken) 호출
5. 그리고 계정 삭제!

*/

import Foundation
import FirebaseAuth
import AuthenticationServices
import CryptoKit

class AuthService {
    // 현재 인증된 사용자 가져오기
    func getCurrentUser() -> User? {
        guard let firebaseUser = Auth.auth().currentUser else { return nil }
        return User(user: firebaseUser)
    }
    
    // 로그아웃
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    // Firebase로 Apple 인증 처리
    func signInWithCredential(credential: AuthCredential) async throws -> User {
        let authResult = try await Auth.auth().signIn(with: credential)
        return User(user: authResult.user)
    }
    
    // 프로필 업데이트
    func updateUserProfile(displayName: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthService", code: 0, userInfo: nil)
        }
        
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = displayName
        try await changeRequest.commitChanges()
    }
    
    // 토큰 취소 및 계정 삭제
    func deleteAccount(withAuthorizationCode authorizationCode: String) async throws {
        guard let _ = Auth.auth().currentUser else {
            throw NSError(domain: "AuthService", code: 0, userInfo: nil)
        }
        
        // 토큰 취소
        try await Auth.auth().revokeToken(withAuthorizationCode: authorizationCode)
        
        // 계정 삭제
        try await Auth.auth().currentUser?.delete()
    }
    
    // 사용자 재인증
    func reauthenticateUser(with credential: AuthCredential) async throws {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "AuthService", code: 0, userInfo: nil)
        }
        
        try await user.reauthenticate(with: credential)
    }
}
