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
                if !viewModel.isAuthenticated {
                    LoginView()
                        .environmentObject(viewModel)
                        .environmentObject(userViewModel)
                } else if userViewModel.isLoading {
                    // 아무것도 없어도 될듯?
                    // 어차피 앱이 커지는 화면 보이니까..?
                } else if !userViewModel.didSelectInterests {
                    InterestsView()
                        .environmentObject(viewModel)
                        .environmentObject(userViewModel)
                } else {
                    CustomTabView()
                        .environmentObject(viewModel)
                        .environmentObject(userViewModel)
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                userViewModel.fetchUserState()
            }
        }
    }
}
