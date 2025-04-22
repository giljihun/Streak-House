//
//  Streak_HouseApp.swift
//  Streak House
//
//  Created by 길지훈 on 4/16/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    
    // 개발용: 앱 실행 시 강제 로그아웃
    // try? Auth.auth().signOut()

    return true
  }
}

@main
struct Streak_HouseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var viewModel = AuthViewModel()
    
    @AppStorage("didSelectInterests") private var didSelectInterests: Bool = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if !viewModel.isAuthenticated {
                    LoginView(didSelectInterests: $didSelectInterests)
                        .environmentObject(viewModel)
                } else if !didSelectInterests {
                    InterestsView(didSelectInterests: $didSelectInterests)
                        .environmentObject(viewModel)
                } else {
                    CustomTabView()
                        .environmentObject(viewModel)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
