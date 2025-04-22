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
    
    init(id: String, email: String, displayName: String, photoURL: String? = nil) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.didSelectInterests = false
        self.interests = []
        self.joinedAt = Date()
    }
}
