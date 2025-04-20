//
//  TabView.swift
//  Streak House
//
//  Created by 길지훈 on 4/20/25.
//
import SwiftUI

struct CustomTabView: View {
    var body: some View {
        TabView {
            StreaksView()
                .tabItem {
                    Label("Streaks", systemImage: "flame.fill")
                }
                .tag(0)
            
            DiscoveryView()
                .tabItem {
                    Label("Discovery", systemImage: "fireplace.fill")
                }
                .tag(1)
            
            AlertsView()
                .tabItem {
                    Label("Alerts", systemImage: "bell.fill")
                }
                .tag(2)
            
            MyProfileView(viewModel: AuthViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
    }
}

#Preview {
    CustomTabView()
}
