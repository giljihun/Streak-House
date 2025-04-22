//
//  InterestsView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//
import SwiftUI

struct InterestsView: View {
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    
//    1.    Growth
//    2.    Wellness
//    3.    Creative
//    4.    Leisure
    
    let allInterests = [
        "Health & Fitness", "Lifestyle", "Music", "Career Growth", "Learning",
        "Personal Growth", "Art & Creativity", "Finance", "Reading",
        "Mindfulness", "Coding", "Writing",
        "Photography", "Cooking", "Languages"
    ]
    
    @State private var selectedInterests: Set<String> = []
    
    var body: some View {
            VStack(alignment: .leading) {
                Text("Interests")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 18)
                    .padding(.bottom, 2)
                
                Text("Choose topics you'd like to build streaks around")
                    .font(.system(size: 16))
                    .foregroundColor(Color(.systemGray))
                    .padding(.bottom, 18)
                
                // Chips
                ChipsContainerView(
                    items: allInterests,
                    selectedItems: $selectedInterests
                )
                
                Spacer()
                
                Button(action: {
                    userViewModel.saveUserInterests(Array(selectedInterests))
                }) {
                    Text("Continue ( \(selectedInterests.count) selected )")
                        .frame(maxWidth: .infinity, minHeight: 43)
                        .font(.system(size: 14, weight: .regular))
                }
                .background(selectedInterests.isEmpty ? Color(.systemGray6) : Color.accentColor)
                .foregroundStyle(selectedInterests.isEmpty ? Color.gray : Color.white)
                .cornerRadius(8)
                .padding(.bottom, 23)
            }
            .padding(.horizontal, 16)
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    InterestsView()
        .environmentObject(UserViewModel())
}
