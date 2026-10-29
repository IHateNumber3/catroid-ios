
import Foundation
import UIKit

public class CatroidApplication: NSObject, UIApplicationDelegate {

    private static let tag = "CatroidApplication"

    private(set) static var shared: CatroidApplication!
    public private(set) static var defaultSystemLanguage: String = ""

    public var window: UIWindow?

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        CatroidApplication.shared = self

        print("[\(CatroidApplication.tag)] Application launched")

        CatroidApplication.defaultSystemLanguage =
            Locale.preferredLanguages.first ?? Locale.current.identifier

        setupAnalytics()

        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainMenu = MainMenuViewController()
        let navigationController =
            UINavigationController(rootViewController: mainMenu)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

    private func setupAnalytics() {
        print("[\(CatroidApplication.tag)] Analytics initialized")
    }

    public static var appContext: Bundle {
        Bundle.main
    }
}
