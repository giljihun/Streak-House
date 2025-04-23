//
//  StreaksViewModel.swift
//  Streak House
//
//  Created by 길지훈 on 4/23/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MyStreaksViewModel: ObservableObject {
    @Published var myStreaks: [Streak] = []
    @Published var editingStreak: Streak?

    func fetchMyStreaks() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        Firestore.firestore().collection("streaks")
            .whereField("createdBy", isEqualTo: uid)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("❌ Error fetching streaks: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.myStreaks = documents.compactMap { doc in
                    try? doc.data(as: Streak.self)
                }
                self.checkAndResetBrokenStreaks()
            }
    }

    func completeStreak(_ streak: Streak) {
        guard !streak.isCompletedToday, let id = streak.id else { return }

        let docRef = Firestore.firestore().collection("streaks").document(id)

        docRef.updateData([
            "lastCheckedAt": FieldValue.serverTimestamp(),
            "streakCount": streak.streakCount + 1
        ]) { error in
            if let error = error {
                print("❌ Failed to complete streak: \(error.localizedDescription)")
            } else {
                print("✅ Streak marked as completed")
                self.fetchMyStreaks()
            }
        }
    }
    
    private func checkAndResetBrokenStreaks() {
        let calendar = Calendar.current
        let today = Date()

        for i in 0..<myStreaks.count {
            let streak = myStreaks[i]
            if let lastCheckedAt = streak.lastCheckedAt {
                if !calendar.isDateInToday(lastCheckedAt) &&
                    !calendar.isDateInYesterday(lastCheckedAt) {
                    myStreaks[i].streakCount = 0
                }
            }
        }
    }
    
    func deleteStreak(_ streak: Streak) {
        guard let id = streak.id else { return }
        Firestore.firestore().collection("streaks").document(id).delete { error in
            if let error = error {
                print("❌ Delete failed: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    self.myStreaks.removeAll { $0.id == id }
                }
            }
        }
    }
    
    // TODO: - 수정기능은 추후!!
    func startEditing(_ streak: Streak) {
        editingStreak = streak
    }
    
    func updateStreak(_ updated: Streak) {
        guard let id = updated.id else { return }
        do {
            try Firestore.firestore().collection("streaks").document(id).setData(from: updated)
            if let index = myStreaks.firstIndex(where: { $0.id == id }) {
                myStreaks[index] = updated
            }
        } catch {
            print("❌ Failed to update streak: \(error.localizedDescription)")
        }
    }
}
