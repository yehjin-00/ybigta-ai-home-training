/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Delegate class for the application.
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 5.0)
        return true
    }
    var window: UIWindow?
}
