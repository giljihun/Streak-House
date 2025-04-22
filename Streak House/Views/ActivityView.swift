//
//  AlertsView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("Activities")
                .font(.system(size: 32, weight: .semibold))
                .padding([.top, .bottom], 12)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                VStack(alignment: .leading) {
                    
                    
                }
                Spacer(minLength: 50)
                
            }
            .frame(maxWidth: .infinity)
            .background(Color(#colorLiteral(red: 0.9756051898, green: 0.9805480838, blue: 0.9847753644, alpha: 1)))
        }
    }
}


#Preview {
    ActivityView()
}
