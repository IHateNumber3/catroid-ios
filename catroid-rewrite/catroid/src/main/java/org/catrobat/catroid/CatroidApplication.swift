import UIKit

@objc(CatroidApplication)
public final class CatroidApplication: UIResponder, UIApplicationDelegate {
    public static var shared: CatroidApplication!
    public static var defaultSystemLanguage = ""
    public var window: UIWindow?

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Self.shared = self
        Self.defaultSystemLanguage = Locale.preferredLanguages.first ?? Locale.current.identifier

        // Create the app window before doing any optional setup.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .systemBackground
        let root = MainMenuViewController()
        root.view.backgroundColor = .systemBackground
        window.rootViewController = UINavigationController(rootViewController: root)
        self.window = window
        window.makeKeyAndVisible()

        return true
    }

    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Reassert the root controller if another startup path left the window empty.
        guard let window = self.window else { return }
        if window.rootViewController == nil {
            window.rootViewController = UINavigationController(rootViewController: MainMenuViewController())
        }
        window.makeKeyAndVisible()
    }

    public static var appContext: Bundle { .main }
}
