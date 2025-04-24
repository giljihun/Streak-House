//
//  UserViewModel.swift
//  Streak House
//
//  Created by 길지훈 on 4/22/25.
//

/*
 [👤 UserViewModel.swift - 사용자 정보 처리 흐름 요약]

 - saveUserInterests(_:): Firestore에 사용자 관심사 저장
*/

import SwiftUI
import FirebaseAuth
import FirebaseFirestore


class UserViewModel: ObservableObject {
    @Published var didSelectInterests: Bool = false
    @Published var isLoading: Bool = true

    func saveUserInterests(_ interests: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()

        db.collection("users").document(uid).updateData([
            "didSelectInterests": true,
            "interests": interests
        ]) { error in
            if let error = error {
                print("❌ 관심사 저장 실패: \(error)")
            } else {
                print("✅ 관심사 저장 완료!")
                DispatchQueue.main.async {
                    self.didSelectInterests = true
                }
            }
        }
    }

    func fetchUserState(completion: @escaping () -> Void = {}) {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.isLoading = false
            completion()
            return
        }
        let docRef = Firestore.firestore().collection("users").document(uid)

        docRef.getDocument { snapshot, error in
            DispatchQueue.main.async {
                if let data = snapshot?.data() {
                    self.didSelectInterests = data["didSelectInterests"] as? Bool ?? false
                } else {
                    self.didSelectInterests = false
                }
                self.isLoading = false
                completion()
            }
        }
    }
}
