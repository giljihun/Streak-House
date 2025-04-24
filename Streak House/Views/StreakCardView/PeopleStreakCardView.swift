//
//  PeopleStreakCardView.swift
//  Streak House
//
//  Created by 길지훈 on 4/23/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PeopleStreakCardView: View {
    let streak: Streak
    let onPin: (Streak) -> Void
    let onCheer: (Streak) -> Void
    
    @State private var cheerScale = 1.0
    @State private var pinScale = 1.0
    @State private var hasCheeredTemp: Bool
    @State private var localPinCount: Int
    @State private var didPin = false
    @State private var showCheerAfterPin = false
    
    init(
        streak: Streak,
        isPinned: Bool,
        onPin: @escaping (Streak) -> Void,
        onCheer: @escaping (Streak) -> Void
    ) {
        self.streak = streak
        self._hasCheeredTemp = State(initialValue: streak.hasBeenCheered(by: Auth.auth().currentUser?.uid ?? ""))
        self._localPinCount = State(initialValue: streak.pinnedCount)
        self.onPin = onPin
        self.onCheer = onCheer
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                
                HStack(spacing: 2) {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 13))
                        .foregroundColor(.gray.opacity(0.6))
                    Text(formatCount(localPinCount))
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.6))
                }
                //.padding(.top, 4)
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(streak.creatorDisplayName ?? "Someone")'s")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(streak.title)
                            .font(.headline.bold())
                            .foregroundColor(.primary)

                        HStack(spacing: 4) {
                            Text("\(streak.streakCount)")
                                .font(.headline.bold())
                                .foregroundColor(.orange)
                            Text("days Streak 🔥")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 6)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack(spacing: 14) {
                    VStack(spacing: 2) {
                        if !streak.isPinned(by: Auth.auth().currentUser?.uid ?? "") && !didPin {
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                    pinScale = 1.2
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    pinScale = 1.0
                                    withAnimation {
                                        didPin = true
                                        showCheerAfterPin = true
                                    }
                                }
                                onPin(streak)
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: "pin")
                                    Text("Pin")
                                }
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.gray.opacity(0.1))
                                .foregroundColor(.gray)
                                .cornerRadius(12)
                            }
                            .scaleEffect(pinScale)
                        }
                    }

                    if true {
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                cheerScale = 1.2
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                cheerScale = 1.0
                            }
                            hasCheeredTemp = true
                            onCheer(streak)
                        }) {
                            Label(
                                (hasCheeredTemp || streak.hasBeenCheered(by: Auth.auth().currentUser?.uid ?? "")) ? "Cheered!" : "Cheer",
                                systemImage: "hands.clap.fill"
                            )
                            .font(.caption)
                            .foregroundColor((hasCheeredTemp || streak.hasBeenCheered(by: Auth.auth().currentUser?.uid ?? "")) ? .white : .orange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background((hasCheeredTemp || streak.hasBeenCheered(by: Auth.auth().currentUser?.uid ?? "")) ? Color.orange : Color.orange.opacity(0.15))
                            .cornerRadius(12)
                        }
                        .scaleEffect(cheerScale)
                        .disabled(hasCheeredTemp || streak.hasBeenCheered(by: Auth.auth().currentUser?.uid ?? ""))
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .offset(y: 6)
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
    }
}

private func formatCount(_ count: Int) -> String {
    
    // MARK: - 밀리언 단위도 추가?ㅋㅋ
    if count >= 1000 {
        let formatted = Double(count) / 1000
        return String(format: "%.1fk", formatted)
    } else {
        return "\(count)"
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    PeopleStreakCardView(
        streak: Streak(
            title: "Coding C2 Project",
            category: "Growth",
            goalTime: 20,
            alarmTime: 0,
            icon: "book.fill",
            createdAt: Date(),
            createdBy: "other_user",
            lastCheckedAt: nil,
            streakCount: 5,
            pinnedCount: 3,
            cheeredCount: 8,
            iconColorHex: "#FF9900"
        ),
        isPinned: true,
        onPin: { _ in },
        onCheer: { _ in }
    )
}
