import UIKit

/// Shows the project currently held by the ported model layer.
/// Disk enumeration/loading is intentionally delegated to ProjectSerializing;
/// the archive currently does not register an iOS serializer.
public final class ProjectListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    public static let importLocalIntentKey = "merge"
    public var isImportMode = false
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private var projectNames: [String] = []

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = isImportMode ? "Импорт из проекта" : "Мои проекты"
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProjectCell")
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        if !isImportMode {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add, target: self, action: #selector(createProject)
            )
        }
        reloadProjects()
    }

    private func reloadProjects() {
        projectNames.removeAll()
        if let current = ProjectManager.shared.currentProject {
            projectNames.append(current.name)
        }
        tableView.reloadData()
        tableView.backgroundView = projectNames.isEmpty ? emptyState() : nil
    }

    private func emptyState() -> UIView {
        let label = UILabel()
        label.text = "Пока нет открытых проектов.\nСоздайте проект через кнопку +."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        return label
    }

    @objc private func createProject() {
        let alert = UIAlertController(title: "Новый проект", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Название проекта"; $0.text = "Мой проект" }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Создать", style: .default) { [weak self, weak alert] _ in
            let name = alert?.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !name.isEmpty else { self?.showError("Введите название проекта."); return }
            do {
                try ProjectManager.shared.createNewEmptyProject(name: name, landscapeMode: false, castEnabled: false)
                self?.reloadProjects()
                self?.navigationController?.pushViewController(ProjectViewController(), animated: true)
            } catch {
                self?.showError("Не удалось создать проект: \(error.localizedDescription)")
            }
        })
        present(alert, animated: true)
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { projectNames.count }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = projectNames[indexPath.row]
        content.image = UIImage(systemName: "folder")
        content.secondaryText = "Открытый проект"
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(ProjectViewController(), animated: true)
    }
}
