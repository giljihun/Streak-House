//
//  LoginView.swift
//  Streak House
//
//  Created by 길지훈 on 4/16/25.
//

import SwiftUI
import DotLottie
import AuthenticationServices

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                DotLottieAnimation(
                    webURL: "https://lottie.host/b877a9a4-4547-4ec9-b110-c197c30e5099/a2UcN8423y.lottie",
                    config: AnimationConfig(autoplay: true, loop: true)
                )
                .view()
                .frame(width: 225, height: 225)
                .padding(.top, 140)
                .padding(.bottom, -30)
                
                Text("Streak House")
                    .font(.system(size: 50, weight: .bold))
                    .padding(.bottom, 14)
                
                Text("Achieve goals together, support each other")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 0.294, green: 0.334, blue: 0.389, alpha: 1)))
                    .padding(.bottom, 160)
                
                Text("By continuing, you agree to our Terms of Service and Privacy Policy.")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 0.610, green: 0.640, blue: 0.686, alpha: 1)))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 0.5)
                
                Text("We collect and process your data to enhance your experience.")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(Color(#colorLiteral(red: 0.610, green: 0.640, blue: 0.686, alpha: 1)))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 14)
                
                if viewModel.isLoading {
                    ProgressView("Logging in...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                        .padding(.top, 20)
                } else {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        // Apple 로그인 결과를 처리하는 메서드 호출
                        viewModel.startSignInWithAppleFlow()
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(width: 361, height: 54)
                    .cornerRadius(12)
                }
            }
            .onAppear {
                // 로그인 상태 확인
                viewModel.checkAuthStatus()
            }
            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                OnBoardingView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    LoginView()
}
