//
//  CelebrationView.swift
//  Streak House
//
//  Created by 길지훈 on 4/23/25.
//

import SwiftUI

struct CelebrationView: View {
    let streak: Streak
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 56))
                    .foregroundColor(.orange)

                Text("🔥 You Did It!")
                    .font(.title.bold())

                Text("You've kept this streak going for \(streak.streakCount) days!")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Button("Awesome!") {
                    withAnimation(.spring()) {
                        onDismiss()
                    }
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .padding(32)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 30)
            .padding(.horizontal, 32)
            .transition(.scale.combined(with: .opacity))
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: UUID()) // forces re-animation
        }
    }
}

#Preview {
    CelebrationView(
        streak: Streak(
            title: "Test Streak",
            category: "Wellness",
            goalTime: 20,
            alarmTime: 0,
            icon: "flame.fill",
            createdAt: Date(),
            createdBy: "sample",
            lastCheckedAt: nil,
            streakCount: 5,
            pinnedCount: 0,
            cheeredCount: 0,
            iconColorHex: "#FF9900"
        ),
        onDismiss: {}
    )
}
