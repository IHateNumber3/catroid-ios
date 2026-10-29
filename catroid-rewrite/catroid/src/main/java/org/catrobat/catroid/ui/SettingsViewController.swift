import UIKit

public class SettingsViewController: UIViewController {
    
    private static let tag = "SettingsViewController"
    
    // Ключ для открытия настроек доступности (аналог SETTINGS_FRAGMENT_INTENT_KEY)
    public var showAccessibilitySettings: Bool = false
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Настройки" // Эквивалент R.string.preference_title
        
        setupNavigationBar()
        setupTableView()
        
        if showAccessibilitySettings {
            openAccessibilitySettings()
        }
    }
    
    private func setupNavigationBar() {
        // Кнопка возврата назад (эквивалент DisplayHomeAsUpEnabled)
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func openAccessibilitySettings() {
        print("[\(SettingsViewController.tag)] Opening Accessibility Settings...")
        // Переход к контроллеру специальных возможностей
        // let accessibilityVC = AccessibilitySettingsViewController()
        // navigationController?.pushViewController(accessibilityVC, animated: true)
    }
    
    @objc private func backTapped() {
        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            navigationController.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // Пример количества секций настроек (Общие, Язык, Доступность)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "SettingsCell")
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Язык приложения"
            cell.detailTextLabel?.text = "Системный"
        case 1:
            cell.textLabel?.text = "Специальные возможности"
        case 2:
            cell.textLabel?.text = "О программе"
        default:
            cell.textLabel?.text = ""
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 1 {
            openAccessibilitySettings()
        }
    }
}
