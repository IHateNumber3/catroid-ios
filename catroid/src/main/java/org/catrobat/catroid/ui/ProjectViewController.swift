import UIKit

public enum ProjectFragmentPosition {
    case scenes
    case sprites
}

public class ProjectViewController: UIViewController {
    
    private static let tag = "ProjectViewController"
    
    public var fragmentPosition: ProjectFragmentPosition = .scenes
    
    // Элементы UI (аналог ActivityRecyclerBinding)
    private let containerView = UIView()
    private let bottomBarView = UIView()
    private val addButton = UIButton(type: .system)
    private val playButton = UIButton(type: .system)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Проект"
        
        setupNavigationBar()
        setupLayout()
        setupBottomBarActions()
        
        loadFragment(position: fragmentPosition)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        
        let optionsButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(optionsTapped)
        )
        navigationItem.rightBarButtonItem = optionsButton
    }
    
    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        view.addSubview(bottomBarView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomBarView.topAnchor),
            
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        bottomBarView.backgroundColor = .secondarySystemBackground
        
        // Настройка кнопок нижней панели (Add & Play)
        addButton.setTitle("Добавить", for: .normal)
        playButton.setTitle("Запустить", for: .normal)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBarView.addSubview(addButton)
        bottomBarView.addSubview(playButton)
        
        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 20),
            addButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            
            playButton.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor)
        ])
    }
    
    private func setupBottomBarActions() {
        addButton.addTarget(self, action: #selector(handleAddButton), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(handlePlayButton), for: .touchUpInside)
    }
    
    private func loadFragment(position: ProjectFragmentPosition) {
        // Логика переключения между контроллером списка сцен и списка спрайтов
        switch position {
        case .scenes:
            print("[\(ProjectViewController.tag)] Loading SceneListViewController")
            // addChild(SceneListViewController())
        case .sprites:
            print("[\(ProjectViewController.tag)] Loading SpriteListViewController")
            // addChild(SpriteListViewController())
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleAddButton() {
        print("[\(ProjectViewController.tag)] Add button tapped.")
        // В зависимости от текущего экрана вызываем добавление сцены или спрайта
    }
    
    @objc private func handlePlayButton() {
        print("[\(ProjectViewController.tag)] Play button tapped. Starting stage...")
        // Запуск StageScene / StageViewController
    }
    
    @objc private func optionsTapped() {
        print("[\(ProjectViewController.tag)] Project options tapped.")
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Автоматическое сохранение проекта при уходе с экрана (аналог onPause)
        saveProjectAsync()
    }
    
    private func saveProjectAsync() {
        print("[\(ProjectViewController.tag)] Saving project asynchronously...")
    }
}
