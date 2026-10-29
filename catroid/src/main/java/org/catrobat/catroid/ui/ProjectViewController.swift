import UIKit

public enum ProjectFragmentPosition { case scenes, sprites }

/// Project overview backed by ProjectManager's current in-memory Project.
public final class ProjectViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    public var fragmentPosition: ProjectFragmentPosition = .scenes
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let segmented = UISegmentedControl(items: ["Сцены", "Спрайты"])
    private var rows: [String] = []

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = ProjectManager.shared.currentProject?.name ?? "Проект"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"), style: .plain,
            target: self, action: #selector(showProjectOptions)
        )
        segmented.selectedSegmentIndex = fragmentPosition == .scenes ? 0 : 1
        segmented.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmented.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
        view.addSubview(segmented)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            segmented.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            segmented.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmented.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: segmented.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        reloadRows()
    }

    private func reloadRows() {
        guard let project = ProjectManager.shared.currentProject else { rows = []; tableView.reloadData(); return }
        switch fragmentPosition {
        case .scenes:
            rows = project.sceneList.map { $0.name }
        case .sprites:
            rows = (ProjectManager.shared.currentlyEditedScene?.spriteList ?? []).map { $0.name }
        }
        tableView.reloadData()
        tableView.backgroundView = rows.isEmpty ? emptyState() : nil
    }

    private func emptyState() -> UIView {
        let label = UILabel()
        label.text = "Здесь пока пусто"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }

    @objc private func segmentChanged() {
        fragmentPosition = segmented.selectedSegmentIndex == 0 ? .scenes : .sprites
        reloadRows()
    }

    @objc private func showProjectOptions() {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Обновить список", style: .default) { [weak self] _ in self?.reloadRows() })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        if let popover = alert.popoverPresentationController { popover.barButtonItem = navigationItem.rightBarButtonItem }
        present(alert, animated: true)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { rows.count }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = rows[indexPath.row]
        content.image = UIImage(systemName: fragmentPosition == .scenes ? "rectangle.on.rectangle" : "person.crop.square")
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard fragmentPosition == .scenes,
              let scene = ProjectManager.shared.currentProject?.getSceneByName(rows[indexPath.row]) else { return }
        ProjectManager.shared.currentlyEditedScene = scene
        fragmentPosition = .sprites
        segmented.selectedSegmentIndex = 1
        reloadRows()
    }
}
