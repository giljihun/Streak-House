//
//  DiscoveryView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//

import SwiftUI

struct DiscoveryView: View {
    
    @State private var selectedCategory: String = "Study"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Discovery")
                .font(.system(size: 32, weight: .semibold))
                .padding([.top, .bottom], 12)
                .padding(.bottom, 2)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                // MARK: - 카테고리 피커
                Picker("Category", selection: $selectedCategory) {
                    Text("All").tag("All")
                    Text("Study").tag("Study")
                    Text("Health").tag("Health")
                    Text("Creativity").tag("Creativity")
                    Text("Fun").tag("Fun")
                }
                .pickerStyle(.segmented)
                .padding([.horizontal, .vertical], 16)
                .padding(.bottom, -8)
                
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Image("trophies")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            
                            Text("Longest Running Streaks")
                                .font(.system(size: 18, weight: .medium))
                            
                            Spacer()
                        }
                        .padding([.horizontal, .vertical], 16)
                        
                        Spacer(minLength: 50)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Spacer()
            }
            .background(Color(#colorLiteral(red: 0.9755851626, green: 0.9805569053, blue: 0.9847741723, alpha: 1)))
        }
    }
}

#Preview {
    DiscoveryView()
}

