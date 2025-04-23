import Foundation
import FirebaseFirestore
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
}
