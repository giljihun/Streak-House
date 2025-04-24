import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PeopleStreakCardView: View {
    let streak: Streak
    let onPin: (Streak) -> Void
    let onCheer: (Streak) -> Void
    
    @State private var isUpdating = false
    @State private var cheerScale = 1.0
    @State private var pinScale = 1.0
    @State private var hasCheeredTemp: Bool
    @State private var didPin = false
    @State private var showCheerAfterPin = false
    @State private var cheerVisible = false
    @State private var cheerOffset: CGFloat = 0
    
    init(
        streak: Streak,
        isPinned: Bool,
        onPin: @escaping (Streak) -> Void,
        onCheer: @escaping (Streak) -> Void
    ) {
        self.streak = streak
        self._hasCheeredTemp = State(initialValue: streak.hasBeenCheered(by: Auth.auth().currentUser?.uid ?? ""))
        self.onPin = onPin
        self.onCheer = onCheer
    }

    var body: some View {
        let currentUser = Auth.auth().currentUser?.uid ?? ""
        let isCheered = hasCheeredTemp || streak.hasBeenCheered(by: currentUser)
        
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                
                HStack(spacing: 2) {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 13))
                        .foregroundColor(.gray.opacity(0.6))
                    Text(formatCount(streak.pinnedCount))
                        .font(.caption2)
                        .foregroundColor(.gray.opacity(0.6))
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(streak.creatorDisplayName ?? "Someone")'s")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text(streak.title)
                            .font(.subheadline.bold())
                            .foregroundColor(.primary)

                        HStack(spacing: 4) {
                            Text("\(streak.streakCount)")
                                .font(.subheadline.bold())
                                .foregroundColor(.orange)
                            Text("days 🔥")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 8)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                
                VStack {
                    Spacer(minLength: 0)

                    VStack(spacing: 14) {
                        if !streak.isPinned(by: Auth.auth().currentUser?.uid ?? "") && !didPin {
                            if isUpdating {
                                ProgressView()
                                    .scaleEffect(0.6)
                                    .padding(.top, 8)
                            } else {
                                Button(action: {
                                    isUpdating = true
                                    onPin(streak)
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                                        pinScale = 1.2
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        pinScale = 1.0
                                        withAnimation(.easeInOut(duration: 0.8)) {
                                            didPin = true
                                            cheerOffset = -6
                                        }
                                        isUpdating = false
                                    }
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
                                isCheered ? "Cheered!" : "Cheer",
                                systemImage: "hands.clap.fill"
                            )
                            .font(.caption)
                            .foregroundColor(isCheered ? .white : .orange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(isCheered ? Color.orange : Color.orange.opacity(0.15))
                            .cornerRadius(12)
                        }
                        .scaleEffect(cheerScale)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: cheerScale)
                        .disabled(isCheered)
                        .offset(y: cheerOffset + (didPin ? 4 : 0))
                        .animation(.easeInOut(duration: 0.8), value: cheerOffset)
                    }

                    Spacer(minLength: 0)
                }
                .frame(maxHeight: .infinity)
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
        isPinned: false,
        onPin: { _ in },
        onCheer: { _ in }
    )
}
