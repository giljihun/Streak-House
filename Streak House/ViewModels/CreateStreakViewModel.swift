//
//  CreateStreakViewModel.swift
//  Streak House
//
//  Created by 길지훈 on 4/23/25.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class CreateStreakViewModel: ObservableObject {
    @Published var selectedCategory: String = "Study"
    @Published var goalText: String = ""
    @Published var selectedTime: Date = Date()
    @Published var selectedAlarmTime: Date = Date()
    @Published var iconColor: Color = .red
    
    var categoryIconName: String {
        switch selectedCategory {
        case "Study": return "book.fill"
        case "Health": return "figure.run"
        case "Creativity": return "paintbrush.fill"
        case "Fun": return "gamecontroller.fill"
        default: return "sparkles"
        }
    }
    
    func saveStreak(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        let newStreak = Streak(
            title: goalText,
            category: selectedCategory,
            
            goalTime: Calendar.current.component(.hour, from: selectedTime) * 60 +
            Calendar.current.component(.minute, from: selectedTime),
            
            // TODO:  알림 시간 로직 수정. -> 노티용이기에 적절한 변형 필요
            alarmTime: Calendar.current.component(.hour, from: selectedAlarmTime) * 60 +
            Calendar.current.component(.minute, from: selectedAlarmTime),
            
            icon: categoryIconName,
            createdAt: Date(),
            createdBy: userId,
            lastCheckedAt: nil,
            streakCount: 0,
            pinnedCount: 0,
            cheeredCount: 0,
            iconColorHex: iconColor.toHex()
        )
        
        do {
            try Firestore.firestore().collection("streaks").addDocument(from: newStreak) { error in
                if let error = error {
                    print("❌ Failed to save streak: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("✅ Streak saved successfully!")
                    completion(true)
                }
            }
        } catch {
            print("❌ Encoding error: \(error.localizedDescription)")
            completion(false)
        }
    }
}
