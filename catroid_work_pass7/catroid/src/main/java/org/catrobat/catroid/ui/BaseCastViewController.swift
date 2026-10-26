import UIKit
// Импорт фреймворка для трансляции при необходимости (например, GoogleCast или AVKit для AirPlay)
// import GoogleCast

open class BaseCastViewController: BaseViewController {
    
    private static let tag = "BaseCastViewController"
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupCastButton()
    }

    private func setupCastButton() {
        let isCastEnabled = UserDefaults.standard.bool(forKey: "cast_shared_preference")
        if isCastEnabled {
            print("[\(BaseCastViewController.tag)] Cast feature enabled, setting up cast button in navigation bar.")
            
            // Добавление кнопки трансляции в правый угол навигационной панели
            let castButton = UIBarButtonItem(
                image: UIImage(systemName: "tv.badge.wifi"),
                style: .plain,
                target: self,
                action: #selector(handleCastButtonTapped)
            )
            
            // Сохраняем существующие элементы и добавляем кнопку трансляции
            var rightItems = navigationItem.rightBarButtonItems ?? []
            rightItems.append(castButton)
            navigationItem.rightBarButtonItems = rightItems
        }
    }

    @objc private func handleCastButtonTapped() {
        print("[\(BaseCastViewController.tag)] Cast button tapped. Opening device selector or disconnect dialog...")
        // Логика вызова диалога выбора устройства трансляции (аналог CastManager.getInstance().openDeviceSelectorOrDisconnectDialog())
    }
}
