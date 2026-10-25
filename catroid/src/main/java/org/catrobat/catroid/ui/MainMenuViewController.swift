import UIKit

public class MainMenuViewController: UIViewController {
    
    private static let tag = "MainMenuViewController"
    
    private var oldPrivacyPolicy: Int = 0
    private let termsOfUseAcceptedVersion = 1 // Эквивалент Constants.CATROBAT_TERMS_OF_USE_ACCEPTED
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Catroid"
        
        // Настройка дефолтных значений и языка
        setupPreferences()
        
        // Проверка версии принятой политики конфиденциальности
        oldPrivacyPolicy = UserDefaults.standard.integer(forKey: "AGREED_TO_PRIVACY_POLICY_VERSION")
        
        loadContent()
        
        if oldPrivacyPolicy != termsOfUseAcceptedVersion {
            showTermsOfUseDialog()
        }
    }
    
    private func setupPreferences() {
        // Установка стандартных настроек (аналог SharedPreferences в Android)
        UserDefaults.standard.register(defaults: [
            "AGREED_TO_PRIVACY_POLICY_VERSION": 0
        ])
    }
    
    private func loadContent() {
        // Настройка главного интерфейса и навигационной панели
        setupNavigationBar()
        setupMainMenuView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Добавление кнопки настроек в тулбар (аналог options menu)
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(settingsTapped)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func setupMainMenuView() {
        // Добавление контейнера под главное меню (эквивалент MainMenuFragment)
        let label = UILabel()
        label.text = "Главное меню Catroid"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // MARK: - Terms of Use Dialog
    
    private func showTermsOfUseDialog() {
        let alert = UIAlertController(
            title: "Условия использования",
            message: "Пожалуйста, примите Условия использования и Политику конфиденциальности для продолжения работы с Catroid.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Принять", style: .default) { [weak self] _ in
            self?.handleAgreedToPrivacyPolicyButton()
        })
        
        alert.addAction(UIAlertAction(title: "Отклонить", style: .cancel) { [weak self] _ in
            self?.handleDeclinedPrivacyPolicyButton()
        })
        
        // Блокируем закрытие по тапу вне алерта (setCancelable(false))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func handleAgreedToPrivacyPolicyButton() {
        UserDefaults.standard.set(termsOfUseAcceptedVersion, forKey: "AGREED_TO_PRIVACY_POLICY_VERSION")
        print("[\(MainMenuViewController.tag)] Terms of use accepted.")
    }
    
    private func handleDeclinedPrivacyPolicyButton() {
        let alert = UIAlertController(
            title: "Внимание",
            message: "Вы должны принять условия использования, чтобы использовать приложение.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.showTermsOfUseDialog()
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions & Menu
    
    @objc private func settingsTapped() {
        // Переход на экран настроек (эквивалент SettingsActivity)
        print("[\(MainMenuViewController.tag)] Open settings tapped.")
        // let settingsVC = SettingsViewController()
        // navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Сохранение проекта при паузе (аналог onPause)
        saveCurrentProjectAsync()
    }
    
    private func saveCurrentProjectAsync() {
        // Асинхронное сохранение текущего проекта
        print("[\(MainMenuViewController.tag)] Saving current project asynchronously...")
    }
}
