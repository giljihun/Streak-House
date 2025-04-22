//
//  MyStreakCardView.swift
//  Streak House
//
//  Created by 길지훈 on 4/23/25.
//

import SwiftUI

struct MyStreakCardView: View {
    let streak: Streak

    var durationText: String {
        let hours = streak.goalTime / 60
        let minutes = streak.goalTime % 60
        if hours > 0 {
            return "\(hours)h"
        } else {
            return "\(minutes)m"
        }
    }
    
    var cheerMessage: String {
        if streak.cheeredCount == 0 {
            let messages = [
                "Today is the start of your challenge!",
                "No cheers yet, but they’re coming soon!",
                "Waiting for your first cheer!",
                "Your challenge is full of potential!"
            ]
            return messages.randomElement() ?? "You got this!"
        } else {
            return "  \(formatCount(streak.cheeredCount)) people are cheering for you!"
        }
    }

    var isCompleted: Bool {
        false
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                HStack(spacing: 6) {
                    Image(systemName: streak.icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .foregroundColor(Color(hex: streak.iconColorHex) ?? .black)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(streak.title)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.primary)

                        Text(durationText)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                HStack(spacing: 3) {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.gray.opacity(0.6))
                    Text(formatCount(streak.pinnedCount))
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.6))
                }
                .padding(.top, 24)
                .padding(.trailing, 20)
            }

            HStack {
                Text(cheerMessage)
                    .font(.footnote)
                    .foregroundColor(.gray)

                Spacer()

                Button(action: {
                    print("Streak completed tapped")
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(isCompleted ? .white : .orange)
                        Text("\(streak.streakCount)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(isCompleted ? .white : .orange)
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .background(isCompleted ? Color.orange : Color.orange.opacity(0.15))
                    .cornerRadius(18)
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

private func formatCount(_ count: Int) -> String {
    if count >= 1000 {
        let formatted = Double(count) / 1000
        return String(format: "%.1fk", formatted)
    } else {
        return "\(count)"
    }
}

// 이렇게하면 사이즈에 맞게 보여줌
#Preview(traits: .sizeThatFitsLayout) {
    MyStreakCardView(
        streak: Streak(
            title: "Morning Workout",
            category: "Exercise",
            goalTime: 120,
            icon: "figure.run",
            createdAt: Date(),
            createdBy: "user123",
            lastCheckedAt: nil,
            streakCount: 90,
            pinnedCount: 210,
            cheeredCount: 5,
            iconColorHex: Color.red.toHex()
        )
    )
    .padding()
}
