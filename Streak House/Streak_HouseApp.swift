//
//  Streak_HouseApp.swift
//  Streak House
//
//  Created by 길지훈 on 4/16/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Streak_HouseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var viewModel = AuthViewModel()
    @State private var didSelectInterests = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if !viewModel.isAuthenticated {
                    LoginView()
                } else if !didSelectInterests {
                    InterestsView(didSelectInterests: $didSelectInterests)
                } else {
                    StreaksView()
                }
            }
        }
    }
}
