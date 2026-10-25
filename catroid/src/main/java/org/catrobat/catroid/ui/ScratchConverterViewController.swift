import UIKit

public enum ScratchConverterFragmentPosition {
    case search
    case projects
}

public class ScratchConverterViewController: BaseViewController {
    
    private static let tag = "ScratchConverterViewController"
    
    private var runningJobs: [Job] = []
    private var finishedJobs: [Job] = []
    
    private let bottomBarView = UIView()
    private let titleLabel = UILabel()
    private let detailsLabel = UILabel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Настройка заголовка с пометкой Beta
        title = "Конвертер Scratch (Beta)"
        
        setupNavigationBar()
        setupBottomBar()
        loadInitialFragment()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBackAction)
        )
    }
    
    private func setupBottomBar() {
        bottomBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomBarView.backgroundColor = .secondarySystemBackground
        bottomBarView.isHidden = true // Изначально скрыт, как в Android-коде
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBarView.addSubview(titleLabel)
        bottomBarView.addSubview(detailsLabel)
        view.addSubview(bottomBarView)
        
        NSLayoutConstraint.activate([
            bottomBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBarView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(equalTo: bottomBarView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor),
            
            detailsLabel.trailingAnchor.constraint(equalTo: bottomBarView.trailingAnchor, constant: -16),
            detailsLabel.centerYAnchor.constraint(equalTo: bottomBarView.centerYAnchor)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomBarTapped))
        bottomBarView.addGestureRecognizer(tapGesture)
    }
    
    private func loadInitialFragment() {
        print("[\(ScratchConverterViewController.tag)] Loading Scratch search results fragment...")
        // Загрузка начального поискового фрагмента
    }
    
    @objc private func bottomBarTapped() {
        print("[\(ScratchConverterViewController.tag)] Bottom bar tapped, switching fragments.")
    }
    
    private func updateBottomBar() {
        titleLabel.text = "В процессе: \(runningJobs.count)"
        detailsLabel.text = "Завершено: \(finishedJobs.count)"
        
        if !runningJobs.isEmpty || !finishedJobs.isEmpty {
            bottomBarView.isHidden = false
        } else {
            bottomBarView.isHidden = true
        }
    }
}
