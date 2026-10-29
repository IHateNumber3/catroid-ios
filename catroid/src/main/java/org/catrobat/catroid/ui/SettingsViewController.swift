import UIKit

public final class SettingsViewController: UITableViewController {
    public var showAccessibilitySettings = false
    private let sections: [[String]] = [
        ["Язык приложения", "Специальные возможности"],
        ["О Catroid", "Условия использования"]
    ]

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Настройки"
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        if showAccessibilitySettings {
            DispatchQueue.main.async { [weak self] in self?.showInfo(title: "Специальные возможности", message: "Используются системные настройки доступности iOS.") }
        }
    }

    public override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].count }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = sections[indexPath.section][indexPath.row]
        cell.accessoryType = .disclosureIndicator
        if indexPath.section == 0 && indexPath.row == 0 {
            cell.detailTextLabel?.text = Locale.preferredLanguages.first ?? Locale.current.identifier
        }
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = sections[indexPath.section][indexPath.row]
        switch item {
        case "Язык приложения":
            showInfo(title: item, message: "Язык приложения определяется настройками языка iOS.")
        case "Специальные возможности":
            showInfo(title: item, message: "Настройки доступности управляются в приложении «Настройки» iOS.")
        case "О Catroid":
            showInfo(title: item, message: "Catroid — визуальная среда программирования. Это экспериментальный iOS-порт.")
        default:
            showInfo(title: item, message: "Условия использования и политика конфиденциальности должны быть подключены к официальным документам проекта.")
        }
    }

    private func showInfo(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
