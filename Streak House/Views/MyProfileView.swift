//
//  AlertsView.swift
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
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        HStack {
                            Spacer()
                            Button("Edit") {
                                // Edit 로직 필요
                            }
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.blue)
                        }
                        
                        HStack(spacing: 16) {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 70, height: 70)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(viewModel.currentUser?.displayName ?? "Unknown user")
                                    .font(.system(size: 20, weight: .semibold))
                                Text("Consistency is key 🔥")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 24) {
                            statBlock(title: "Active Streaks", value: "15", color: .orange)
                            statBlock(title: "Total Cheers", value: "142", color: .blue)
                            statBlock(title: "Days Frozen", value: "30", color: .purple)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        Button(action: {
                            // TODO: Interests 수정 로직 필요!!
                        }) {
                            profileMenuRow(title: "Interests", icon: "heart", trailing: Text("Edit").foregroundColor(.blue))
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
                        
                        profileMenuRow(title: "My Streaks", icon: "flame.fill", trailing: Text("15 active").foregroundColor(.gray))
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
                        
                        profileMenuRow(title: "Freezing Usage", icon: "snowflake", trailing: Text("2 remaining").foregroundColor(.gray))
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
                        
                        Button(action: {
                            // TODO: 세팅 로직 필요
                        }) {
                            profileMenuRow(title: "Settings", icon: "gearshape", trailing: Image(systemName: "chevron.right").foregroundColor(.gray))
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
                        
                        Button(action: {
                            viewModel.signOut()
                        }) {
                            profileMenuRow(title: "Log Out", icon: "arrowshape.turn.up.left", trailing: EmptyView(), color: .red)
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
                        
                        Button(action: {
                            viewModel.deleteAccount()
                        }) {
                            profileMenuRow(title: "Delete Account", icon: "xmark.circle.fill", trailing: EmptyView(), color: .red)
                        }
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 1)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
                .padding(.bottom, 16)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0.9755851626, green: 0.9805569053, blue: 0.9847741723, alpha: 1)))
            .overlay {
                if viewModel.isLoading {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView("Processing...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
    }
    
    private func statBlock(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func profileMenuRow<Content: View>(title: String, icon: String, trailing: Content, color: Color = .primary) -> some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .foregroundColor(color)
            }
            Spacer()
            trailing
        }
        .padding()
    }
}

#Preview {
    MyProfileView()
        .environmentObject(AuthViewModel())
}
