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
    @StateObject var userViewModel = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashView()
                    .environmentObject(viewModel)
                    .environmentObject(userViewModel)
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                userViewModel.fetchUserState()
            }
        }
    }
}
