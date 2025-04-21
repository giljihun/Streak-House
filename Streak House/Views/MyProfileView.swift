//
//  MyProfileView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//

import SwiftUI

struct MyProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var goToInterests = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text("My Profile")
                .font(.system(size: 32, weight: .semibold))
                .padding([.top, .bottom], 12)
                .padding(.bottom, 2)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                VStack {
                    Spacer().frame(height: 40)
                    
                    Text("👋 Welcome to Streak House!")
                        .font(.system(size: 20, weight: .bold))
                    
                    if let user = viewModel.currentUser {
                        Text("You're logged in as: \(user.displayName ?? user.email ?? "Unknown")")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                
                    HStack(alignment: .center, spacing: 16) {
                        
                        Button("Log Out") {
                            viewModel.signOut()
                        }
                        .foregroundColor(.red)
                        Button("Delete Account") {
                            viewModel.deleteAccount()
                        }
                        .foregroundColor(.red)
                    }
                    
                    // 로딩 표시
                    if viewModel.isLoading {
                        ProgressView("Processing...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color(#colorLiteral(red: 0.9755851626, green: 0.9805569053, blue: 0.9847741723, alpha: 1)))
            
            Spacer()
        }
    }
}

#Preview {
    MyProfileView()
}
