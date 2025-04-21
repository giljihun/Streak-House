//
//  TabView.swift
//  Streak House
//
//  Created by 길지훈 on 4/20/25.
//
import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        TabView(selection: $selectedTab) {
            StreaksView(selectedTab: $selectedTab)
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
            
            MyProfileView()
                .tabItem {
                    Label("My Profile", systemImage: "person.fill")
                }
                .tag(3)
        }
    }
}


#Preview {
    CustomTabView()
}
