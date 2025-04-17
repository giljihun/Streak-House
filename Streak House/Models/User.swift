//
//  User.swift
//  Streak House
//
//  Created by 길지훈 on 4/17/25.
//
import Foundation
import FirebaseAuth

struct User: Identifiable, Codable {
    let id: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    
    init(user: FirebaseAuth.User) {
        self.id = user.uid
        self.email = user.email
        self.displayName = user.displayName
        self.photoURL = user.photoURL
    }
    
    init(id: String, email: String?, displayName: String?, photoURL: URL?) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
    }
}
