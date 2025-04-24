import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject private var discoveryViewModel = DiscoveryViewModel()
    @State private var selectedCategory = "Study"

    @State private var showCelebrate = false
    @State private var selectedStreak: Streak?

    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                StreaksView(selectedTab: $selectedTab, onCelebrate: { streak in
                    selectedStreak = streak
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                        showCelebrate = true
                    }
                })
                .tabItem {
                    Label("Streaks", systemImage: "flame.fill")
                }
                .tag(0)

                DiscoveryView(selectedCategory: $selectedCategory)
                    .environmentObject(discoveryViewModel)
                    .tabItem {
                        Label("Discovery", systemImage: "fireplace.fill")
                    }
                    .tag(1)

                ActivityView()
                    .tabItem {
                        Label("Activity", systemImage: "sparkles")
                    }
                    .tag(2)

                MyProfileView()
                    .tabItem {
                        Label("My Profile", systemImage: "person.fill")
                    }
                    .tag(3)
            }
            .onChange(of: selectedTab) { newTab in
                if newTab == 1 {
                    
                    selectedCategory = "Fun"
                    selectedCategory = "Study"

                    discoveryViewModel.fetchStreaks(for: "Study")
                }
            }

            // MyStreak -> 스트릭 완료 표현
            if showCelebrate, let streak = selectedStreak {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    VStack(spacing: 24) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 56))
                            .foregroundColor(.orange)

                        Text("🔥 You Did It!")
                            .font(.title.bold())

                        let displayStreakCount = max(1, streak.streakCount + 1)
                        Text("You've kept this streak going for \(displayStreakCount) days!")
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Button("Awesome!") {
                            withAnimation(.spring()) {
                                showCelebrate = false
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
                    // .transition(.move(edge: .bottom).combined(with: .opacity)) // 아래에서 위로 올라오는 애니메이션으로 변경
                }
                .zIndex(1)
            }
        }
    }
}

#Preview {
    CustomTabView()
        .environmentObject(AuthViewModel())
}
