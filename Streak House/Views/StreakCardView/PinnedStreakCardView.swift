//  PinnedStreakCardView.swift
//  Streak House
//
//  Created by 길지훈 on 4/23/25.
//

import SwiftUI

struct PinnedStreakCardView: View {
    let creatorName: String
    let title: String
    let streakCount: Int
    let isCheered: Bool
    let onUnpin: () -> Void
    let onCheer: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text(creatorName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Text("·")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                    Text(title)
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(.primary)
                }
                Text(isCheered ? "They feel your support!" : "Cheer On your Fellow!")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            if streakCount > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(streakCount)")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            } else {
                Button(action: {
                    onCheer()
                }) {
                    Text(isCheered ? "Cheered!" : "Cheer")
                        .font(.caption)
                        .foregroundColor(isCheered ? .gray : .orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(isCheered ? Color.gray.opacity(0.15) : Color.orange.opacity(0.15))
                        .cornerRadius(20)
                }
                .disabled(isCheered)
            }

            Menu {
                Button(role: .destructive) {
                    onUnpin()
                } label: {
                    Text("Unpin")
                }
                
                Button(role: .destructive) {
                    //
                } label: {
                    Text("Hi, I'm Gil 👋")
                }
                
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                            .padding([.top, .bottom], 12) // 여유롭게 패딩 줌
                            .contentShape(Rectangle()) // 실제 터치 영역을 넓혀줌
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack {
        PinnedStreakCardView(
            creatorName: "Mike",
            title: "Reading Challenge",
            streakCount: 24,
            isCheered: true,
            onUnpin: {},
            onCheer: {}
        )
        
        PinnedStreakCardView(
            creatorName: "Sarah",
            title: "Morning Run",
            streakCount: 0,
            isCheered: false,
            onUnpin: {},
            onCheer: {
                print("Cheered!")
            }
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
