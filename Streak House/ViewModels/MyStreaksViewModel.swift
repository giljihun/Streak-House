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
            }
    }
}
