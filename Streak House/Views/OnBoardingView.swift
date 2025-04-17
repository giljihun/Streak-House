//
//  ContentView.swift
//  Streak House
//
//  Created by 길지훈 on 4/16/25.
//

import SwiftUI

struct OnBoardingView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
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
        }
    }
}


#Preview {
    OnBoardingView(viewModel: AuthViewModel())
}
