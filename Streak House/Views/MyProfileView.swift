//
//  MyProfileView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//

import SwiftUI

struct MyProfileView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        
        // TODO: - 여기에 닉네임(이메일) 환영합니다!를 하고
        // 1. 인디케이터로 설명?
        // 2. 그냥 시작하기로 관심사 선택으로 이동?
    
        VStack(spacing: 20) {
            Text("👋 Welcome to Streak House!")
                .font(.largeTitle)
                .bold()
                .padding()

            if let user = viewModel.currentUser {
                Text("You're logged in as: \(user.displayName ?? "Unknown")")
            }

            Button("Log Out") {
                viewModel.signOut()
            }
            .foregroundColor(.red)
            .padding()
            
            Button("Delete Account") {
                viewModel.deleteAccount()
            }
            .foregroundColor(.red)
            .padding()
            
            // 로그인 버튼 또는 로딩 표시
            if viewModel.isLoading {
                ProgressView("logging out...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    // .padding(.top, 20)
            }
            
        }.navigationBarBackButtonHidden()
    }
}

#Preview {
    MyProfileView(viewModel: AuthViewModel())
}
