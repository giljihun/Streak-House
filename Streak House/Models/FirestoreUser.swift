//
//  FirestoreUser.swift
//  Streak House
//
//  Created by 길지훈 on 4/22/25.
//


import Foundation
import FirebaseFirestore

struct FirestoreUser: Identifiable, Codable {
    // 애플로그인 -> uid 부여받음
    @DocumentID var id: String?
    var email: String
    var displayName: String
    var photoURL: String?
    var didSelectInterests: Bool
    var interests: [String]
    var joinedAt: Date
    var pinnedStreakIDs: [String] = []
    var resolution: String
    
    // 사는 지역 ---> 왜냐면 스트릭 초기화 시간을 맞추기 위해
    var timezone: String?
    
    init(id: String, email: String, displayName: String, photoURL: String? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        
        // TODO: - 애플계정 프로필 사진을 가져올 수 있을까?
        self.photoURL = photoURL
        self.didSelectInterests = false
        self.interests = []
        self.joinedAt = Date()
        self.pinnedStreakIDs = []
        
        // TODO: - 유저 결심 넣기
        self.resolution = ""
    }
}
