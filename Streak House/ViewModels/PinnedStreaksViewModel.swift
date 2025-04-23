//
//  PinnedStreaksViewModel.swift
//  Streak House
//
//  Created by 길지훈 on 4/23/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class PinnedStreaksViewModel: ObservableObject {
    @Published var pinnedStreaks: [PinnedStreak] = []

    func fetchPinnedStreaks(for userId: String) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)

        userRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(),
                  let pinnedIDs = data["pinnedStreakIDs"] as? [String] else {
                print("❌ Failed to load pinnedStreakIDs")
                return
            }

            let group = DispatchGroup()
            var loadedStreaks: [PinnedStreak] = []

            for id in pinnedIDs {
                group.enter()
                db.collection("streaks").document(id).getDocument { doc, error in
                    defer { group.leave() }

                    guard let doc = doc, doc.exists,
                          let title = doc["title"] as? String,
                          let streakCount = doc["streakCount"] as? Int else { return }

                    let currentUserId = Auth.auth().currentUser?.uid ?? ""
                    let cheeredUsers = doc["cheeredUserIDs"] as? [String] ?? []
                    let isCheered = cheeredUsers.contains(currentUserId)

                    guard let creatorId = doc["createdBy"] as? String else { return }

                    db.collection("users").document(creatorId).getDocument { userDoc, error in
                        let creatorName = userDoc?["displayName"] as? String ?? "Unknown"

                        let streak = PinnedStreak(
                            id: doc.documentID,
                            title: title,
                            creatorName: creatorName,
                            streakCount: streakCount,
                            isCheered: isCheered
                        )
                        loadedStreaks.append(streak)
                    }
                }
            }

            group.notify(queue: .main) {
                self.pinnedStreaks = loadedStreaks
            }
        }
    }

    func cheer(for streakId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let docRef = Firestore.firestore().collection("streaks").document(streakId)

        docRef.updateData([
            "cheeredUserIDs": FieldValue.arrayUnion([userId]),
            "cheeredCount": FieldValue.increment(Int64(1))
        ]) { error in
            if let error = error {
                print("❌ Cheer failed: \(error.localizedDescription)")
            } else {
                print("✅ Cheer success")
                // Reload the list to reflect new cheer state
                self.fetchPinnedStreaks(for: userId)
            }
        }
    }
}
