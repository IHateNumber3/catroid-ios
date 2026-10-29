import UIKit

public class ProjectUploadViewController: BaseViewController {
    
    private static let tag = "ProjectUploadViewController"
    
    private var isNotesAndCreditsScreen = false
    private var enableNextButton = true
    
    // UI элементы
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let projectImageView = UIImageView()
    private let projectNameTextField = UITextField()
    private let projectDescriptionTextView = UITextView()
    private let progressBar = UIActivityIndicatorView(style: .large)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Загрузка проекта" // Эквивалент R.string.upload_project_dialog_title
        
        setupNavigationBar()
        setupLayout()
        
        setShowProgressBar(true)
        loadProjectActivity()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBackAction)
        )
        
        let nextButton = UIBarButtonItem(
            title: "Далее",
            style: .done,
            target: self,
            action: #selector(onNextButtonClick)
        )
        navigationItem.rightBarButtonItem = nextButton
    }
    
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        view.addSubview(progressBar)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            progressBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setShowProgressBar(_ show: Bool) {
        progressBar.isHidden = !show
        if show {
            progressBar.startAnimating()
            scrollView.isHidden = true
        } else {
            progressBar.stopAnimating()
            scrollView.isHidden = false
        }
    }
    
    private func loadProjectActivity() {
        print("[\(ProjectUploadViewController.tag)] Loading project activity and tags...")
        // Загрузка тегов и проверка подлинности пользователя (verifyUserIdentity)
        verifyUserIdentity()
    }
    
    private func verifyUserIdentity() {
        let token = UserDefaults.standard.string(forKey: "TOKEN") ?? ""
        if token.isEmpty {
            startSignInWorkflow()
        } else {
            // Проверка валидности токена
            onCreateView()
        }
    }
    
    private func onCreateView() {
        setShowProgressBar(false)
        print("[\(ProjectUploadViewController.tag)] Project upload view configured successfully.")
    }
    
    private func startSignInWorkflow() {
        print("[\(ProjectUploadViewController.tag)] Starting sign in workflow...")
        // Открытие экрана авторизации
    }
    
    @objc private func onNextButtonClick() {
        if !isNotesAndCreditsScreen {
            isNotesAndCreditsScreen = true
            print("[\(ProjectUploadViewController.tag)] Switching to notes and credits screen.")
        } else {
            print("[\(ProjectUploadViewController.tag)] Starting project upload process...")
            showSelectTagsDialog()
        }
    }
    
    private func showSelectTagsDialog() {
        let alert = UIAlertController(title: "Выберите теги", message: "Укажите теги для вашего проекта", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Загрузить", style: .default, handler: { _ in
            print("Upload started with tags.")
            self.showUploadDialog()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func showUploadDialog() {
        let alert = UIAlertController(title: "Загрузка", message: "Идет загрузка проекта на сервер...", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }
}
