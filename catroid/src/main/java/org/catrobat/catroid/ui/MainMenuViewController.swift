import UIKit

public final class MainMenuViewController: UIViewController {
    private let projectsButton = UIButton(type: .system)
    private let createButton = UIButton(type: .system)

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Catroid"
        navigationController?.navigationBar.prefersLargeTitles = false

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(settingsTapped)
        )

        let logo = UIImageView(image: UIImage(systemName: "puzzlepiece.extension"))
        logo.tintColor = .systemBlue
        logo.contentMode = .scaleAspectFit
        logo.translatesAutoresizingMaskIntoConstraints = false

        let heading = UILabel()
        heading.text = "Pocket Code"
        heading.font = .systemFont(ofSize: 30, weight: .bold)
        heading.textAlignment = .center
        heading.translatesAutoresizingMaskIntoConstraints = false

        let subtitle = UILabel()
        subtitle.text = "Создавай свои проекты"
        subtitle.font = .preferredFont(forTextStyle: .subheadline)
        subtitle.textColor = .secondaryLabel
        subtitle.textAlignment = .center
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        configureButton(projectsButton, title: "Мои проекты", symbol: "folder")
        projectsButton.addTarget(self, action: #selector(openProjects), for: .touchUpInside)
        configureButton(createButton, title: "Создать проект", symbol: "plus")
        createButton.addTarget(self, action: #selector(createProject), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [logo, heading, subtitle, projectsButton, createButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 18
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -28),
            logo.heightAnchor.constraint(equalToConstant: 76),
            projectsButton.heightAnchor.constraint(equalToConstant: 52),
            createButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func configureButton(_ button: UIButton, title: String, symbol: String) {
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
        let controller = ProjectListViewController()
        controller.startWithCreateDialog = true
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc private func settingsTapped() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
