import UIKit

open class BaseViewController: UIViewController {
    
    private static let tag = "BaseViewController"
    
    // Флаг ожидания восстановления состояния (аналог savedInstanceStateExpected)
    protected var savedInstanceStateExpected: Bool = false

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        applyAccessibilityStyles()
        checkIfCrashRecoveryAndFinish()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupEdgeToEdgeInsets()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackScreenResume()
    }

    // MARK: - Configuration & Styles
    
    private func applyAccessibilityStyles() {
        // Применение настроек доступности (динамический размер шрифта, контрастность)
        let isAccessibilityEnabled = UserDefaults.standard.bool(forKey: "accessibility_enabled")
        if isAccessibilityEnabled {
            print("[\(BaseViewController.tag)] Applying accessibility styles.")
        }
    }

    private func setupEdgeToEdgeInsets() {
        // Настройка безопасности отступов для iOS (эквивалент EdgeToEdge.applyTopPadding / BottomPadding)
        additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    // MARK: - Analytics & Tracking
    
    private func trackScreenResume() {
        let screenName = String(describing: type(of: self))
        print("[GoogleAnalytics] Tracking screen view: \(screenName)")
    }

    // MARK: - Crash Recovery
    
    private func checkIfCrashRecoveryAndFinish() {
        let isRecoveringFromCrash = UserDefaults.standard.bool(forKey: "RECOVERED_FROM_CRASH")
        if isRecoveringFromCrash {
            // Если это не главный экран, закрываем контроллер при восстановлении после краша
            if !(self is MainMenuViewController) {
                print("[\(BaseViewController.tag)] Recovered from crash, dismissing view controller.")
                dismiss(animated: false, completion: nil)
            } else {
                UserDefaults.standard.set(false, forKey: "RECOVERED_FROM_CRASH")
            }
        }
    }

    // MARK: - Navigation / Back Action
    
    @objc open func handleBackAction() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
