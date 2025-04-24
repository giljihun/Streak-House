//
//  DiscoveryView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//

import Foundation
import FirebaseFirestore

class DiscoveryViewModel: ObservableObject {
    @Published var streaks: [Streak] = []

    func fetchStreaks(for category: String) {
        let db = Firestore.firestore()
        db.collection("streaks")
            .whereField("category", isEqualTo: category)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching streaks: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ No documents found")
                    return
                }

                var fetchedStreaks: [Streak] = []
                var userCache: [String: String] = [:]
                let dispatchGroup = DispatchGroup()

                for doc in documents {
                    do {
                        var streak = try doc.data(as: Streak.self)
                        let uid = streak.createdBy

                        if let cachedName = userCache[uid] {
                            streak.creatorDisplayName = cachedName
                            fetchedStreaks.append(streak)
                        } else {
                            dispatchGroup.enter()
                            db.collection("users").document(uid).getDocument { userDoc, _ in
                                if let userData = userDoc?.data(),
                                   let name = userData["displayName"] as? String {
                                    userCache[uid] = name
                                    streak.creatorDisplayName = name
                                } else {
                                    streak.creatorDisplayName = "Unknown"
                                }
                                fetchedStreaks.append(streak)
                                dispatchGroup.leave()
                            }
                        }
                    } catch {
                        print("❌ Error decoding streak: \(error)")
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self.streaks = fetchedStreaks
                }
            }
    }
    
    func togglePin(for streak: Streak, currentUserId: String) {
        let userRef = Firestore.firestore().collection("users").document(currentUserId)
        let streakRef = Firestore.firestore().collection("streaks").document(streak.id ?? "")
        let isCurrentlyPinned = streak.pinnedBy?.contains(currentUserId) ?? false

        userRef.updateData([
            "pinnedStreakIDs": isCurrentlyPinned ?
                FieldValue.arrayRemove([streak.id ?? ""]) :
                FieldValue.arrayUnion([streak.id ?? ""])
        ])

        streakRef.updateData([
            "pinnedCount": FieldValue.increment(isCurrentlyPinned ? Int64(-1) : 1),
            "pinnedBy": isCurrentlyPinned ?
                FieldValue.arrayRemove([currentUserId]) :
                FieldValue.arrayUnion([currentUserId])
        ])
    }

    func cheerStreak(_ streak: Streak, currentUserId: String) {
        guard !(streak.cheeredBy?.contains(currentUserId) ?? false) else {
            print("⚠️ Already cheered.")
            return
        }

        let streakRef = Firestore.firestore().collection("streaks").document(streak.id ?? "")
        streakRef.updateData([
            "cheeredCount": FieldValue.increment(Int64(1)),
            "cheeredBy": FieldValue.arrayUnion([currentUserId])
        ])
    }
}
