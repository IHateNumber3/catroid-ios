import Foundation
import UIKit

public class CatroidApplication: NSObject, UIApplicationDelegate {

    public var window: UIWindow?
    
    private static let tag = "CatroidApplication"
    
    // Синглтон для доступа к инстансу приложения
    private(set) static var shared: CatroidApplication!
    
    // Аналог defaultSystemLanguage
    public private(set) static var defaultSystemLanguage: String = ""
    
    public func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        CatroidApplication.shared = self

        // This app uses UIApplicationMain directly, so install its initial screen here.
        let appWindow = UIWindow(frame: UIScreen.main.bounds)
        appWindow.rootViewController = UINavigationController(
            rootViewController: MainMenuViewController()
        )
        appWindow.makeKeyAndVisible()
        self.window = appWindow
        
        print("[\(CatroidApplication.tag)] CatroidApplication onCreate (iOS Port)")
        
        // Получаем информацию о коммите (если прописано в Info.plist, иначе "unknown")
        let commitInfo = Bundle.main.object(forInfoDictionaryKey: "GitCommitInfo") as? String ?? "unknown"
        print("[\(CatroidApplication.tag)] git commit info: \(commitInfo)")
        
        // Системный язык (аналог Locale.getDefault().toLanguageTag())
        CatroidApplication.defaultSystemLanguage = Locale.preferredLanguages.first ?? Locale.current.identifier
        
        // 1. Инициализация DI (если ядро на KMP/Kotlin, вызываем его старт, иначе здесь твой аналог Koin/Swinject)
        // CatroidKoinHelperKt.start(...)
        
        // 2. Инициализация аналитики (Firebase Analytics вместо старого Google Analytics SDK)
        setupAnalytics()
        
        // Примечание: Huawei Mobile Services (HMS) на iOS не нужны, поэтому этот блок опускаем.
        
        return true
    }
    
    private func setupAnalytics() {
        // Настройка аналитики для iOS
        print("[\(CatroidApplication.tag)] Analytics initialized")
    }
    
    // Аналог getAppContext() (в iOS для ресурсов и манифеста используется Bundle.main)
    public static var appContext: Bundle {
        return Bundle.main
    }
}
