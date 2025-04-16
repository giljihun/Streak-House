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
    var body: some View {
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
                .foregroundColor(Color(#colorLiteral(red: 0.2943475246, green: 0.3345783949, blue: 0.3893696368, alpha: 1)))
                .padding(.bottom, 160)
            
            Text("By continuing, you agree to our Terms of Service and Privacy Policy.")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(Color(#colorLiteral(red: 0.610229075, green: 0.6401827931, blue: 0.6868138909, alpha: 1)))
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .padding(.bottom, 0.5)
            
            Text("We collect and process your data to enhance your experience.")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(Color(#colorLiteral(red: 0.610229075, green: 0.6401827931, blue: 0.6868138909, alpha: 1)))
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .padding(.bottom, 14)
            
            // MARK: - TODO (Firebase - Apple Login 구현)
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    print("로그인 성공: \(authResults)")
                case .failure(let error):
                    print("로그인 실패: \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(width: 361, height: 54)
            .border(Color(#colorLiteral(red: 0.8208512664, green: 0.8357849717, blue: 0.8570175767, alpha: 1)))
            .cornerRadius(12)
        }
    }
}

#Preview {
    LoginView()
}
