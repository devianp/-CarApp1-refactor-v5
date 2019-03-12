
import UIKit

@UIApplicationMain final class ApplicationDelegate: UIResponder {

    var window: UIWindow?
}

extension ApplicationDelegate: UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = UINavigationController(rootViewController: GenerationsViewController())
        self.window!.makeKeyAndVisible()

        return true
    }
}
