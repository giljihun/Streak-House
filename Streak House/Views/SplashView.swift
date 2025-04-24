//
//  SplashView.swift
//  Streak House
//
//  Created by 길지훈 on 4/24/25.
//

import SwiftUI
import DotLottie

struct SplashView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var navigate = false
    
    var body: some View {
        ZStack {
            if navigate {
                if !authViewModel.isAuthenticated {
                    LoginView()
                } else if !userViewModel.didSelectInterests {
                    InterestsView()
                } else {
                    CustomTabView()
                }
            } else {
                
                VStack {
                    // 로고 애니메이션
                    withAnimation {
                        DotLottieAnimation(
                            webURL: "https://lottie.host/b877a9a4-4547-4ec9-b110-c197c30e5099/a2UcN8423y.lottie",
                            config: AnimationConfig(autoplay: true, loop: true)
                        )
                        .view()
                        .frame(width: 225, height: 225)
                        .padding(.top, 140)
                        .padding(.bottom, -30)
                    }
                    // 앱 제목
                    withAnimation {
                        Text("Streak House")
                            .font(.system(size: 50, weight: .bold))
                            .padding(.bottom, 14)
                    }
                    
                    // 앱 설명
                    withAnimation {
                        Text("Achieve goals together, support each other")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color(#colorLiteral(red: 0.294, green: 0.334, blue: 0.389, alpha: 1)))
                            .padding(.bottom, 160)
                    }
                    
                    ProgressView()
                        .transition(.opacity)
                        .onAppear {
                            userViewModel.fetchUserState {
                                withAnimation {
                                    navigate = true
                                }
                            }
                        }
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    SplashView()
        .environmentObject(AuthViewModel())
        .environmentObject(UserViewModel())
}
