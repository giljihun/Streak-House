//
//  Streak.swift
//  Streak House
//
//  Created by 길지훈 on 4/22/25.
//

import Foundation
import FirebaseFirestore

struct Streak: Identifiable, Codable {
    @DocumentID var id: String?
    var title: String
    var category: String
    var goalTime: Int
    var alarmTime: Int
    var icon: String
    var createdAt: Date
    
    // 소유자 UUID
    var createdBy: String
    var creatorDisplayName: String?
    
    var lastCheckedAt: Date?
    var streakCount: Int
    var pinnedCount: Int
    var cheeredCount: Int
    var iconColorHex: String
    
    var cheeredBy: [String]? = []
    var pinnedBy: [String]? = []
    
    var isCompletedToday: Bool {
        guard let lastCheckedAt else {
            return false
        }
        return Calendar.current.isDateInToday(lastCheckedAt)
    }
    
    func isPinned(by userId: String) -> Bool {
        return pinnedBy?.contains(userId) ?? false
    }

    func hasBeenCheered(by userId: String) -> Bool {
        return cheeredBy?.contains(userId) ?? false
    }

}

    
