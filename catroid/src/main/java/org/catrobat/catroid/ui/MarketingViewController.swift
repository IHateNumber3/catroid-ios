import UIKit
import SafariServices

public class MarketingViewController: UIViewController {
    
    private static let tag = "MarketingViewController"
    
    // UI элементы
    private let titleLabel = UILabel()
    private let logoImageView = UIImageView()
    private let googlePlayButton = UIButton(type: .system)
    private let huaweiButton = UIButton(type: .system)
    private let websiteLinkButton = UIButton(type: .system)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Скрытие навигационной панели для полноэкранного режима (эквивалент FEATURE_NO_TITLE / FULLSCREEN)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupLayout()
        configureContent()
        setupActions()
    }
    
    private func setupLayout() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        googlePlayButton.translatesAutoresizingMaskIntoConstraints = false
        huaweiButton.translatesAutoresizingMaskIntoConstraints = false
        websiteLinkButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(titleLabel)
        view.addSubview(logoImageView)
        view.addSubview(googlePlayButton)
        view.addSubview(huaweiButton)
        view.addSubview(websiteLinkButton)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        
        logoImageView.contentMode = .scaleAspectFit
        
        googlePlayButton.setTitle("Google Play Store", for: .normal)
        huaweiButton.setTitle("Huawei AppGallery", for: .normal)
        websiteLinkButton.setTitle("Веб-сайт проекта", for: .normal)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            logoImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            googlePlayButton.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            googlePlayButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            huaweiButton.topAnchor.constraint(equalTo: googlePlayButton.bottomAnchor, constant: 20),
            huaweiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            websiteLinkButton.topAnchor.constraint(equalTo: huaweiButton.bottomAnchor, constant: 20),
            websiteLinkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureContent() {
        // Установка имени проекта (эквивалент ProjectManager.getInstance().getCurrentProject().getName())
        titleLabel.text = "Catroid Standalone Project"
        logoImageView.image = UIImage(named: "pocket_code")
    }
    
    private func setupActions() {
        googlePlayButton.addTarget(self, action: #selector(openGooglePlay), for: .touchUpInside)
        huaweiButton.addTarget(self, action: #selector(openHuaweiGallery), for: .touchUpInside)
        websiteLinkButton.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
    }
    
    @objc private func openGooglePlay() {
        if let url = URL(string: "https://play.google.com/store/apps/details?id=org.catrobat.catroid") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openHuaweiGallery() {
        if let url = URL(string: "https://appgallery.huawei.com/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func openWebsite() {
        if let url = URL(string: "https://share.catrobat.org") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}
