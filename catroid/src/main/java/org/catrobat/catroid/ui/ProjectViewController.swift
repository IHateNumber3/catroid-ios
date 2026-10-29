import UIKit

public enum ProjectFragmentPosition { case scenes, sprites }

public final class ProjectViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let addButton = UIButton(type: .system)
    private let playButton = UIButton(type: .system)
    public var fragmentPosition: ProjectFragmentPosition = .scenes

    private var project: Project? { ProjectManager.shared.currentProject }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = project?.name ?? "Проект"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(optionsTapped))

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        view.addSubview(tableView)

        let bar = UIStackView(arrangedSubviews: [addButton, playButton])
        bar.axis = .horizontal
        bar.distribution = .fillEqually
        bar.spacing = 12
        bar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bar)
        addButton.setTitle("Добавить сцену", for: .normal)
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(addSceneTapped), for: .touchUpInside)
        playButton.setTitle("Запустить", for: .normal)
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor), tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bar.topAnchor, constant: -8),
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16), bar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8), bar.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    @objc private func backTapped() { navigationController?.popViewController(animated: true) }

    @objc private func optionsTapped() {
        let alert = UIAlertController(title: project?.name ?? "Проект", message: "Проект сохраняется на устройстве. Сохранение блоков и ресурсов в стандартный формат Catrobat ещё не подключено.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "ОК", style: .cancel))
        if let pop = alert.popoverPresentationController { pop.barButtonItem = navigationItem.rightBarButtonItem }
        present(alert, animated: true)
    }

    @objc private func addSceneTapped() {
        let alert = UIAlertController(title: "Добавить сцену", message: "Введи название новой сцены", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Сцена 2" }
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Добавить", style: .default) { [weak self, weak alert] _ in
            guard let self, let project = self.project,
                  let name = alert?.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else { return }
            let scene = Scene(name: name, project: project)
            scene.addSprite(Sprite(name: NSLocalizedString("background", value: "Background", comment: "")))
            project.addScene(scene)
            guard ProjectStore.save(project) else {
                let error = UIAlertController(title: "Ошибка сохранения", message: "Сцена добавлена в памяти, но не удалось сохранить её на устройстве.", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "ОК", style: .default))
                self.present(error, animated: true)
                return
            }
            self.tableView.reloadData()
        })
        present(alert, animated: true)
    }

    @objc private func playTapped() {
        let alert = UIAlertController(title: "Запуск проекта", message: "Среда выполнения сцен ещё не подключена. Проект создан и открыт, но запуск пока недоступен.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Понятно", style: .default))
        present(alert, animated: true)
    }
}

extension ProjectViewController: UITableViewDataSource, UITableViewDelegate {
    public func numberOfSections(in tableView: UITableView) -> Int { 1 }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { project?.sceneList.count ?? 0 }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "SceneCell")
        let scene = project?.sceneList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = scene?.name ?? "Сцена"
        content.secondaryText = "\(scene?.spriteList.count ?? 0) объектов"
        content.image = UIImage(systemName: "rectangle.on.rectangle")
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let scene = project?.sceneList[indexPath.row] else { return }
        ProjectManager.shared.currentlyEditedScene = scene
        let alert = UIAlertController(title: scene.name, message: "Сцена содержит \(scene.spriteList.count) объект(ов). Редактор сцен и блоков будет следующим этапом.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
