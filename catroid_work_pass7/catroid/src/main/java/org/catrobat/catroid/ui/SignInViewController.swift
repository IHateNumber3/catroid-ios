import UIKit

public protocol SignInViewControllerDelegate: AnyObject {
    func signInDidCompleteSuccessfully(with info: [String: Any]?)
    func signInDidCancel()
}

public class SignInViewController: BaseViewController {
    
    private static let tag = "SignInViewController"
    public static let loginSuccessfulKey = "LOGIN_SUCCESSFUL"
    
    public weak var delegate: SignInViewControllerDelegate?
    
    // UI элементы
    private let loginButton = UIButton(type: .system)
    private let registerButton = UIButton(type: .system)
    private let googleSignInButton = UIButton(type: .system)
    private let termsOfUseTextView = UITextView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Вход в систему"
        
        setupNavigationBar()
        setupLayout()
        setupActions()
        configureTermsLink()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func setupLayout() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
        termsOfUseTextView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(googleSignInButton)
        view.addSubview(termsOfUseTextView)
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        
        registerButton.setTitle("Регистрация", for: .normal)
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.layer.cornerRadius = 8
        
        googleSignInButton.setTitle("Вход через Google", for: .normal)
        googleSignInButton.backgroundColor = .secondarySystemBackground
        googleSignInButton.setTitleColor(.label, for: .normal)
        googleSignInButton.layer.cornerRadius = 8
        
        termsOfUseTextView.isEditable = false
        termsOfUseTextView.isScrollEnabled = false
        termsOfUseTextView.textAlignment = .center
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.heightAnchor.constraint(equalToConstant: 50),
            
            googleSignInButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleSignInButton.widthAnchor.constraint(equalToConstant: 250),
            googleSignInButton.heightAnchor.constraint(equalToConstant: 50),
            
            termsOfUseTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            termsOfUseTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            termsOfUseTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        googleSignInButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
    }
    
    private func configureTermsLink() {
        let termsText = "Продолжая, вы соглашаетесь с Условиями использования Catrobat."
        let attributedString = NSMutableAttributedString(string: termsText)
        if let range = termsText.range(of: "Условиями использования") {
            let nsRange = NSRange(range, in: termsText)
            attributedString.addAttribute(.link, value: "https://catrob.at/terms", range: nsRange)
        }
        termsOfUseTextView.attributedText = attributedString
    }
    
    @objc private func loginButtonTapped() {
        print("[\(SignInViewController.tag)] Opening Login Dialog...")
        // Показ модального окна входа (эквивалент LoginDialogFragment)
    }
    
    @objc private func registerButtonTapped() {
        print("[\(SignInViewController.tag)] Opening Registration Dialog...")
        // Показ модального окна регистрации (эквивалент RegistrationDialogFragment)
    }
    
    @objc private func googleSignInTapped() {
        print("[\(SignInViewController.tag)] Starting Google Sign In flow...")
        // Интеграция с входом через Google / OAuth
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.signInDidCancel()
        dismiss(animated: true, completion: nil)
    }
    
    public func handleLoginSuccess(info: [String: Any]) {
        delegate?.signInDidCompleteSuccessfully(with: info)
        dismiss(animated: true, completion: nil)
    }
}
