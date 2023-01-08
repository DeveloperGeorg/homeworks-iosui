import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let url = AppConfiguration.allCases.randomElement()!.description
        print("About to get info from url = \(url)")
        NetworkService.run(url: url, query: "") { data, response, error in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)\n")
            } else if
                let data = data,
                let response = response as? HTTPURLResponse {
                print("Status code is \(response.statusCode)")
                print("All headers are:")
                print(response.allHeaderFields)
                if let responseData = String(data: data, encoding: .utf8) {
                    print("Response data is:")
                    print(responseData)
                }
            }
              
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func applicationWillTerminate(_: UIApplication) {
        let checkerService = CheckerService()
        checkerService.logout()
        print("logged out in applicationWillTerminate")
    }

}

