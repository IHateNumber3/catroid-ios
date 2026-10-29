import UIKit

public final class CatroidApplication: NSObject, UIApplicationDelegate {
    private static let tag = "CatroidApplication"

    public private(set) static var shared: CatroidApplication!
    public private(set) static var defaultSystemLanguage: String = ""

    // Retain the window for the lifetime of the app. Without this, the app can
    // launch successfully but never display its root interface.
    public var window: UIWindow?

    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Self.shared = self
        Self.defaultSystemLanguage = Locale.preferredLanguages.first ?? Locale.current.identifier

        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainMenu = MainMenuViewController()
        let navigationController = UINavigationController(rootViewController: mainMenu)
        navigationController.view.backgroundColor = .systemBackground
        window.rootViewController = navigationController
        window.backgroundColor = .systemBackground
        self.window = window
        window.makeKeyAndVisible()

        print("[\(Self.tag)] App launched; root view controller installed")
        return true
    }

    public static var appContext: Bundle { .main }
}
