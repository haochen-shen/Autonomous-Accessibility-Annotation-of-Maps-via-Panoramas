import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow()
    window?.rootViewController = RouteSelectionViewController()
    window?.overrideUserInterfaceStyle = .light
    window?.makeKeyAndVisible()
    // Override point for customization after application launch.
    return true
  }
}
