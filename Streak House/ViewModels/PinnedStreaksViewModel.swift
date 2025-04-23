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
        
        db.collection("streaks")
            .whereField("pinnedBy", arrayContains: userId)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("❌ Failed to fetch pinned streaks")
                    return
                }

                let group = DispatchGroup()
                var loadedStreaks: [PinnedStreak] = []

                for doc in documents {
                    group.enter()
                    
                    let data = doc.data()
                    guard let title = data["title"] as? String,
                          let streakCount = data["streakCount"] as? Int,
                          let creatorId = data["createdBy"] as? String else {
                        group.leave()
                        continue
                    }

                    let cheeredUsers = data["cheeredUserIDs"] as? [String] ?? []
                    let isCheered = cheeredUsers.contains(userId)

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
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self.pinnedStreaks = loadedStreaks
                }
            }
    }
    
    func unpin(streakId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        let streakRef = Firestore.firestore().collection("streaks").document(streakId)

        Firestore.firestore().runTransaction({ transaction, errorPointer in
            transaction.updateData([
                "pinnedBy": FieldValue.arrayRemove([userId]),
                "pinnedCount": FieldValue.increment(Int64(-1))
            ], forDocument: streakRef)

            return nil
        }) { _, error in
            if let error = error {
                print("❌ Unpin failed: \(error)")
            } else {
                self.fetchPinnedStreaks(for: userId) // 리스트 갱신
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
