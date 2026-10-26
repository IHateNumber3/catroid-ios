import UIKit

public class SpriteViewController: BaseViewController {
    
    public static let tag = "SpriteViewController"
    
    public static let fragmentScripts = 0
    public static let fragmentLooks = 1
    public static let fragmentSounds = 2
    
    private var currentFragmentPosition: Int = fragmentScripts
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupTabs()
        loadInitialFragment()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBackAction)
        )
        title = "Редактирование спрайта"
    }
    
    private func setupTabs() {
        print("[\(SpriteViewController.tag)] Setting up tab layout for Sprite view...")
        // Настройка вкладок (Скрипты, Образы, Звуки)
    }
    
    private func loadInitialFragment() {
        print("[\(SpriteViewController.tag)] Loading initial fragment at position: \(currentFragmentPosition)")
        // Загрузка начального фрагмента/контроллера скриптов
    }
    
    @objc private func handlePlayButtonTapped() {
        print("[\(SpriteViewController.tag)] Play button tapped. Running project stage...")
        // Запуск StageActivity / StageViewController
    }
    
    public func addSprite(from uri: URL) {
        print("[\(SpriteViewController.tag)] Adding sprite from URI: \(uri)")
        // Логика добавления спрайта
    }
    
    public func addSound(from uri: URL) {
        print("[\(SpriteViewController.tag)] Adding sound from URI: \(uri)")
        // Логика добавления звука
    }
}
