//
//  MyStreakCardView.swift
//  Streak House
//
//  Created by 길지훈 on 4/23/25.
//

import SwiftUI

struct MyStreakCardView: View {
    @EnvironmentObject var viewModel: MyStreaksViewModel
    let streak: Streak
    let onCelebrate: () -> Void
    @State private var isPressed = false

    var durationText: String {
        let hours = streak.goalTime / 60
        let minutes = streak.goalTime % 60
        if hours > 0 {
            if minutes > 0 {
                return "\(hours)h \(minutes)m"
            } else {
                return "\(hours)h"
            }
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
        streak.isCompletedToday
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    HStack(spacing: 10) {
                        Image(systemName: streak.icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color(hex: streak.iconColorHex) ?? .black)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(streak.title)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)

                            Text(durationText + "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

//                    Spacer()

                    if streak.pinnedCount > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 13))
                                .foregroundColor(.gray.opacity(0.6))
                            Text(formatCount(streak.pinnedCount))
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.6))
                        }
                        .padding(.trailing, 8)
                        .padding(.bottom, 16)
                    }
                    
                        Spacer()
                        
                        Menu {
                            Button("Edit") {
                                viewModel.startEditing(streak)
                            }

                            Button(role: .destructive) {
                                viewModel.deleteStreak(streak)
                            } label: {
                                Text("Delete")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .foregroundColor(.gray)
                                .padding(.trailing, 4)
                                .padding(.bottom, 16)
                        }
                }

                HStack {
                    Text(cheerMessage)
                        .font(.footnote)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeIn(duration: 0.15)) {
                            isPressed = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isPressed = false
                            viewModel.completeStreak(streak)
                            if !streak.isCompletedToday {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    onCelebrate()
                                }
                            }
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(isCompleted ? Color(#colorLiteral(red: 0.9749493003, green: 0.4522024989, blue: 0.08381486684, alpha: 1)) : Color(#colorLiteral(red: 0.4670161009, green: 0.4422878027, blue: 0.4297846556, alpha: 1)))
                            Text("\(streak.streakCount)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(isCompleted ? Color(#colorLiteral(red: 0.9749493003, green: 0.4522024989, blue: 0.08381486684, alpha: 1)) : Color(#colorLiteral(red: 0.4670161009, green: 0.4422878027, blue: 0.4297846556, alpha: 1)))
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(isCompleted ? Color(#colorLiteral(red: 1, green: 0.9309260249, blue: 0.8366528153, alpha: 1)) : Color(#colorLiteral(red: 1, green: 0.9309260249, blue: 0.8366528153, alpha: 1)))
                        .cornerRadius(16)
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                    }
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
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

// 이렇게하면 사이즈에 맞게 보여줌
#Preview(traits: .sizeThatFitsLayout) {
    MyStreakCardView(
        streak: Streak(
            title: "Morning Workout",
            category: "Exercise",
            goalTime: 120,
            alarmTime: 1400,
            icon: "figure.run",
            createdAt: Date(),
            createdBy: "user123",
            lastCheckedAt: nil,
            streakCount: 90,
            pinnedCount: 1210,
            cheeredCount: 5,
            iconColorHex: Color.red.toHex()
        ),
        onCelebrate: { }
    )
    .padding()
    .environmentObject(MyStreaksViewModel())
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
