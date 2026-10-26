import UIKit

public class ScratchProgramDetailsViewController: BaseViewController {
    
    private static let tag = "ScratchProgramDetailsViewController"
    
    public var programData: ScratchProgramData?
    
    // UI элементы
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let ownerLabel = UILabel()
    private let instructionsLabel = UILabel()
    private let creditsLabel = UILabel()
    private let convertButton = UIButton(type: .system)
    private let projectImageView = UIImageView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Детали проекта Scratch (Beta)"
        
        setupNavigationBar()
        setupLayout()
        configureContent()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBackAction)
        )
    }
    
    private func setupLayout() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        ownerLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        creditsLabel.translatesAutoresizingMaskIntoConstraints = false
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        projectImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(projectImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(ownerLabel)
        contentView.addSubview(instructionsLabel)
        contentView.addSubview(creditsLabel)
        contentView.addSubview(convertButton)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        
        ownerLabel.font = UIFont.systemFont(ofSize: 14)
        ownerLabel.textColor = .secondaryLabel
        
        convertButton.setTitle("Конвертировать", for: .normal)
        convertButton.backgroundColor = .systemBlue
        convertButton.setTitleColor(.white, for: .normal)
        convertButton.layer.cornerRadius = 8
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
        
        projectImageView.contentMode = .scaleAspectFit
        projectImageView.backgroundColor = .secondarySystemBackground
        
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
            
            projectImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            projectImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            projectImageView.widthAnchor.constraint(equalToConstant: 250),
            projectImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: projectImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            ownerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            ownerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ownerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            instructionsLabel.topAnchor.constraint(equalTo: ownerLabel.bottomAnchor, constant: 16),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            creditsLabel.topAnchor.constraint(equalTo: instructionsLabel.bottomAnchor, constant: 16),
            creditsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            creditsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            convertButton.topAnchor.constraint(equalTo: creditsLabel.bottomAnchor, constant: 24),
            convertButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            convertButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            convertButton.heightAnchor.constraint(equalToConstant: 50),
            convertButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func configureContent() {
        guard let program = programData else { return }
        titleLabel.text = program.title
        ownerLabel.text = "Автор: \(program.owner)"
        instructionsLabel.text = "Инструкции: \(program.instructions ?? "-")"
        creditsLabel.text = "Примечания и кредиты: \(program.notesAndCredits ?? "-")"
    }
    
    @objc private func convertButtonTapped() {
        print("[\(ScratchProgramDetailsViewController.tag)] Convert button tapped for program ID: \(programData?.id ?? 0)")
        // Логика запуска конвертации через ConversionManager
    }
}
