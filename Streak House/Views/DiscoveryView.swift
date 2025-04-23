//
//  DiscoveryView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//


import SwiftUI
import Firebase
import FirebaseFirestore

struct DiscoveryView: View {
    
    @State private var selectedCategory: String = "Study"
    @StateObject private var viewModel = DiscoveryViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Discovery")
                .font(.system(size: 32, weight: .semibold))
                .padding([.top, .bottom], 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - 카테고리 피커
            Picker("Category", selection: $selectedCategory) {
//                Text("All").tag("All")
                Text("Study").tag("Study")
                Text("Health").tag("Health")
                Text("Creativity").tag("Creativity")
                Text("Fun").tag("Fun")
            }
            .pickerStyle(.segmented)
            .padding([.horizontal, .bottom], 16)
            //.padding(.bottom, -8)
            .onChange(of: selectedCategory) { newCategory in
                viewModel.fetchStreaks(for: newCategory)
            }
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        if let currentUserUID = authViewModel.currentUser?.id {
                            ForEach(viewModel.streaks.filter { $0.createdBy != currentUserUID }) { streak in
                                PeopleStreakCardView(
                                    streak: streak,
                                    isPinned: authViewModel.currentUser?.pinnedStreakIDs.contains(streak.id ?? "") ?? false,
                                    onPin: { streak in
                                        // TODO: Add pin/unpin logic here
                                        print("Pin tapped for \(streak.title)")
                                    },
                                    onCheer: { streak in
                                        // TODO: Add cheer logic here
                                        print("Cheer tapped for \(streak.title)")
                                    }
                                )
                                .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0.9755851626, green: 0.9805569053, blue: 0.9847741723, alpha: 1)))
        }
        .onAppear {
            viewModel.fetchStreaks(for: selectedCategory)
        }
    }
}

#Preview {
    DiscoveryView()
        .environmentObject(AuthViewModel())
}
