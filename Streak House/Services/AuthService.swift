//
//  AuthService.swift
//  Streak House
//
//  Created by 길지훈 on 4/17/25.
//
// AuthService: Firebase 인증 관련 API 호출 담당

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
