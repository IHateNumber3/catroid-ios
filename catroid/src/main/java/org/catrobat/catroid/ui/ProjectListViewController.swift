import UIKit

public final class ProjectListViewController: UIViewController {
    private static let tag = "ProjectListViewController"
    public static let importLocalIntentKey = "merge"
    private let projectsKey = "CatroidProjectNames"

    public var isImportMode = false
    public var startWithCreateDialog = false
    private var projects: [String] = []
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = isImportMode ? "Импорт проекта" : "Мои проекты"
        projects = ProjectStore.projectNames()
        setupNavigationBar()
        setupTableView()
        if startWithCreateDialog {
            DispatchQueue.main.async { [weak self] in self?.handleAddProjectTapped() }
        }
    }

    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"), style: .plain,
            target: self, action: #selector(handleBackAction))
        if !isImportMode {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add, target: self, action: #selector(handleAddProjectTapped))
        }
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func handleBackAction() {
        if let nav = navigationController, nav.viewControllers.count > 1 { nav.popViewController(animated: true) }
        else { dismiss(animated: true) }
    }

    @objc private func handleAddProjectTapped() {
        let alert = UIAlertController(title: "Новый проект", message: "Придумай название проекта", preferredStyle: .alert)
        alert.addTextField { field in field.placeholder = "Например, Моя игра"; field.autocapitalizationType = .sentences }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Создать", style: .default) { [weak self, weak alert] _ in
            guard let self,
                  let name = alert?.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !name.isEmpty else { return }
            guard !self.projects.contains(where: { $0.localizedCaseInsensitiveCompare(name) == .orderedSame }) else {
                let error = UIAlertController(title: "Такой проект уже есть", message: "Выбери другое название.", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "ОК", style: .default))
                self.present(error, animated: true)
                return
            }
            do {
                // Create a real Catroid Project model rather than storing only a label.
                let project = Project(name: name)
                guard ProjectStore.save(project) else {
                    let saveError = UIAlertController(title: "Ошибка сохранения", message: "Не удалось сохранить проект на устройстве.", preferredStyle: .alert)
                    saveError.addAction(UIAlertAction(title: "ОК", style: .default))
                    self.present(saveError, animated: true)
                    return
                }
                ProjectManager.shared.setCurrentProject(project)
                self.projects.append(name)
                self.persistProjects()
                self.tableView.reloadData()
                let editor = ProjectViewController()
                self.navigationController?.pushViewController(editor, animated: true)
            } catch {
                let errorAlert = UIAlertController(title: "Не удалось создать проект", message: error.localizedDescription, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "ОК", style: .default))
                self.present(errorAlert, animated: true)
            }
        })
        present(alert, animated: true)
    }

    private func persistProjects() {
        UserDefaults.standard.set(projects, forKey: projectsKey)
    }
}

extension ProjectListViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int { 1 }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { projects.count }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "ProjectCell")
        var content = cell.defaultContentConfiguration()
        content.text = projects[indexPath.row]
        content.secondaryText = "Нажми, чтобы открыть проект"
        content.image = UIImage(systemName: "folder.fill")
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = projects[indexPath.row]
        // Reconstruct the in-memory model and pass it to the app's project manager.
        // Full XML/assets persistence is a separate step; UserDefaults currently stores names only.
        guard let project = ProjectStore.load(name) else {
            let alert = UIAlertController(title: "Не удалось открыть проект", message: "Файл code.xml отсутствует или повреждён.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ОК", style: .default))
            present(alert, animated: true)
            return
        }
        ProjectManager.shared.setCurrentProject(project)
        let editor = ProjectViewController()
        navigationController?.pushViewController(editor, animated: true)
    }

    public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, done in
            guard let self else { done(false); return }
            let removedName = self.projects.remove(at: indexPath.row)
            ProjectStore.delete(removedName)
            self.persistProjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
