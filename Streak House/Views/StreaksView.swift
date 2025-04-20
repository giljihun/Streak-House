//
//  StreaksView.swift
//  Streak House
//
//  Created by 길지훈 on 4/18/25.
//

import SwiftUI

struct StreaksView: View {
    var body: some View {
        TabView {
            Text("Home View")
                .tabItem {
                    Label("Streaks", systemImage: "house")
                }
            
            Text("Calendar View")
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }	
            
            Text("Settings View")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            
            Text("Settings View")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    StreaksView()
}
