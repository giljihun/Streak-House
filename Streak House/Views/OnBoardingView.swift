//
//  ContentView.swift
//  Streak House
//
//  Created by 길지훈 on 4/16/25.
//
import SwiftUI

struct OnBoardingView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var goToInterests = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                Text("👋 Welcome to Streak House!")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 12)
                
                if let user = viewModel.currentUser {
                    Text("You're logged in as: \(user.displayName ?? user.email ?? "Unknown")")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                
                Text("Set your interests to get personalized streaks and recommendations.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                
                Spacer()
                
                Button(action: {
                    goToInterests = true
                }) {
                    Text("Choose Interests")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color(.systemGray6))
                        .foregroundColor(.gray)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 24)
                
                // 로그아웃/계정삭제 등은 별도 메뉴에서 제공 권장
                /*
                Button("Log Out") { viewModel.signOut() }
                    .foregroundColor(.red)
                Button("Delete Account") { viewModel.deleteAccount() }
                    .foregroundColor(.red)
                */
                
                // 로딩 표시
                if viewModel.isLoading {
                    ProgressView("Processing...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                }
            }
            .padding(.horizontal, 20)
//            .navigationDestination(isPresented: $goToInterests) {
//                InterestsView(didSelectInterests: <#Binding<Bool>#>)
//            }
//            .navigationBarBackButtonHidden()
        }
    }
}


#Preview {
    OnBoardingView(viewModel: AuthViewModel())
}
