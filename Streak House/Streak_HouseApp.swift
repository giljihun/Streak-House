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
                    // 계정 삭제, 계정 변경 시. 버그 발생 방지!
                        .onAppear {
                                didSelectInterests = false
                            }
                } else if !didSelectInterests {
                    InterestsView(didSelectInterests: $didSelectInterests)
                } else {
                    CustomTabView()
                }
            }
        }
    }
}
