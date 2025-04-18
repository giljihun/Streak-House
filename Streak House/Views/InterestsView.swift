//
//  InterestsView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//

import SwiftUI
import _AuthenticationServices_SwiftUI

let allInterests = [
    "Health", "Lifestyle", "Career Growth", "Learning",
    "Personal Growth", "Art & Creativity", "Finance", "Reading",
    "Mindfulness", "Coding", "Writing", "Music",
    "Photography", "Cooking", "Languages"
]

struct InterestsView: View {
    
    @State private var selectedInterests: Set<String> = []
    
    var body: some View {
        
        let columns = [
            GridItem(.adaptive(minimum: 110))
        ]
        
        NavigationStack {
            Text("Choose topics you'd like to build streaks around")
                .foregroundStyle(Color(#colorLiteral(red: 0.294601053, green: 0.3344707489, blue: 0.3893821836, alpha: 1)))
                .padding(.bottom, 24)
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 17) {
                ForEach(allInterests, id: \.self) { interest in
                    Button(action: {
                        if selectedInterests.contains(interest) {
                            selectedInterests.remove(interest)
                        } else {
                            selectedInterests.insert(interest)
                        }
                    }) {
                        Text(interest)
                            .font(.system(size: 13, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(selectedInterests.contains(interest) ? .white : Color(#colorLiteral(red: 0.2160501182, green: 0.256003201, blue: 0.3192771673, alpha: 1)))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(selectedInterests.contains(interest) ? Color.blue : Color(.systemGray6))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Interests")
            .padding(.horizontal, 16)
            Spacer()
            
            Button(action: {
                // TODO: - Continue Func Here.
            }) {
                Text("Continue ( \(selectedInterests.count) selected )")
                    .frame(width: 338, height: 43)
                    .font(.system(size: 16, weight: .semibold))
            }
            .cornerRadius(8)
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 23)
        }
    }
}

#Preview {
    InterestsView()
}
