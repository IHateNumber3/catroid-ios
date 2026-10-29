import UIKit

/// Native iOS entry screen. Keeps navigation real and delegates project creation
/// to the existing model layer instead of simulating actions with log messages.
public final class MainMenuViewController: UIViewController {
    private let stack = UIStackView()
    private let projectsButton = UIButton(type: .system)
    private let newProjectButton = UIButton(type: .system)
    private let settingsButton = UIButton(type: .system)
    private let privacyKey = "AGREED_TO_PRIVACY_POLICY_VERSION"
    private let privacyVersion = 1

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Catroid"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain, target: self, action: #selector(openSettings)
        )
        buildMenu()
        requireTermsIfNeeded()
    }

    private func buildMenu() {
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        let logo = UIImageView(image: UIImage(systemName: "puzzlepiece.extension"))
        logo.tintColor = .systemBlue
        logo.contentMode = .scaleAspectFit
        logo.heightAnchor.constraint(equalToConstant: 88).isActive = true

        configure(projectsButton, title: "Мои проекты", symbol: "folder")
        configure(newProjectButton, title: "Создать проект", symbol: "plus.circle")
        configure(settingsButton, title: "Настройки", symbol: "gearshape")

        stack.addArrangedSubview(logo)
        stack.setCustomSpacing(32, after: logo)
        stack.addArrangedSubview(projectsButton)
        stack.addArrangedSubview(newProjectButton)
        stack.addArrangedSubview(settingsButton)
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            projectsButton.heightAnchor.constraint(equalToConstant: 54),
            newProjectButton.heightAnchor.constraint(equalToConstant: 54),
            settingsButton.heightAnchor.constraint(equalToConstant: 54)
        ])

        projectsButton.addTarget(self, action: #selector(openProjects), for: .touchUpInside)
        newProjectButton.addTarget(self, action: #selector(createProject), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
    }

    private func configure(_ button: UIButton, title: String, symbol: String) {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.image = UIImage(systemName: symbol)
        config.imagePadding = 10
        config.cornerStyle = .medium
        button.configuration = config
    }

    @objc private func openProjects() {
        navigationController?.pushViewController(ProjectListViewController(), animated: true)
    }

    @objc private func createProject() {
        let alert = UIAlertController(title: "Новый проект", message: "Введите название проекта", preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Мой проект"
            field.text = "Мой проект"
            field.clearButtonMode = .whileEditing
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Создать", style: .default) { [weak self, weak alert] _ in
            let name = alert?.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !name.isEmpty else {
                self?.showMessage("Название проекта не может быть пустым.")
                return
            }
            do {
                try ProjectManager.shared.createNewEmptyProject(name: name, landscapeMode: false, castEnabled: false)
                self?.navigationController?.pushViewController(ProjectViewController(), animated: true)
            } catch {
                self?.showMessage("Не удалось создать проект: \(error.localizedDescription)")
            }
        })
        present(alert, animated: true)
    }

    @objc private func openSettings() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }

    private func requireTermsIfNeeded() {
        UserDefaults.standard.register(defaults: [privacyKey: 0])
        guard UserDefaults.standard.integer(forKey: privacyKey) != privacyVersion else { return }
        let alert = UIAlertController(
            title: "Условия использования",
            message: "Для продолжения необходимо принять условия использования и политику конфиденциальности.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Принять", style: .default) { _ in
            UserDefaults.standard.set(self.privacyVersion, forKey: self.privacyKey)
        })
        alert.addAction(UIAlertAction(title: "Отклонить", style: .destructive) { _ in
            self.showMessage("Без принятия условий продолжить работу нельзя.")
        })
        present(alert, animated: true)
    }

    private func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Catroid", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
