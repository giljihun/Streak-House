//
//  DiscoveryView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//

import SwiftUI

struct DiscoveryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Discovery")
                .font(.system(size: 32, weight: .semibold))
                .padding([.top, .bottom], 12)
                .padding(.bottom, 2)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                VStack(alignment: .leading) {

                    Spacer(minLength: 50)
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color(#colorLiteral(red: 0.9755851626, green: 0.9805569053, blue: 0.9847741723, alpha: 1)))
            
            Spacer()
        }
    }
}

#Preview {
    DiscoveryView()
}

