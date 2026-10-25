import UIKit

public class ProjectListViewController: BaseCastViewController {
    
    private static let tag = "ProjectListViewController"
    public static let importLocalIntentKey = "merge"
    
    public var isImportMode: Bool = false
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Список проектов" // Эквивалент R.string.project_list_title
        
        setupNavigationBar()
        setupTableView()
        setupBottomBar()
        
        if isImportMode {
            title = "Импорт из проекта" // Эквивалент R.string.import_from_project
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBackAction)
        )
        
        // Кнопка добавления нового проекта (эквивалент handleAddButton)
        if !isImportMode {
            let addButton = UIBarButtonItem(
                image: UIImage(systemName: "plus"),
                style: .plain,
                target: self,
                action: #selector(handleAddProjectTapped)
            )
            navigationItem.rightBarButtonItem = addButton
        }
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
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupBottomBar() {
        // Управление видимостью кнопок нижней панели (скрываем Play и AI assist)
        print("[\(ProjectListViewController.tag)] Configuring bottom bar elements.")
    }
    
    @objc private func handleAddProjectTapped() {
        print("[\(ProjectListViewController.tag)] Opening New Project Dialog...")
        // Показ диалогового окна создания нового проекта (эквивалент NewProjectDialogFragment)
        let alert = UIAlertController(title: "Новый проект", message: "Введите имя проекта", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Имя проекта"
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Создать", style: .default, handler: { [weak self] _ in
            print("Project created successfully.")
        }))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension ProjectListViewController: UITableViewDelegate, UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0 // Заглушка списка проектов
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "ProjectCell")
        return cell
    }
}
