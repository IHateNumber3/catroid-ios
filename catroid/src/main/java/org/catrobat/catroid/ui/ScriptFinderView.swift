import UIKit

public protocol ScriptFinderDelegate: AnyObject {
    func scriptFinderDidOpen()
    func scriptFinderDidClose()
    func scriptFinderDidFindResult(sceneIndex: Int, spriteIndex: Int, brickIndex: Int, totalResults: Int)
}

public class ScriptFinderView: UIView {
    
    private static let tag = "ScriptFinderView"
    
    public weak var delegate: ScriptFinderDelegate?
    
    private let searchTextField = UITextField()
    private let findButton = UIButton(type: .system)
    private let findNextButton = UIButton(type: .system)
    private let findPreviousButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    private let positionIndicatorLabel = UILabel()
    private let progressBar = UIActivityIndicatorView(style: .medium)
    
    private var searchResults: [[Int]] = []
    private var searchResultIndex = 0
    private var searchQuery = ""
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
        setupActions()
    }
    
    private func setupLayout() {
        backgroundColor = .secondarySystemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.placeholder = "Поиск по скриптам..."
        searchTextField.borderStyle = .roundedRect
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        findButton.setTitle("Найти", for: .normal)
        findButton.translatesAutoresizingMaskIntoConstraints = false
        
        findNextButton.setTitle("Далее", for: .normal)
        findNextButton.isHidden = true
        findNextButton.translatesAutoresizingMaskIntoConstraints = false
        
        findPreviousButton.setTitle("Назад", for: .normal)
        findPreviousButton.isHidden = true
        findPreviousButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        positionIndicatorLabel.text = "0/0"
        positionIndicatorLabel.isHidden = true
        positionIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        progressBar.isHidden = true
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(searchTextField)
        addSubview(findButton)
        addSubview(findNextButton)
        addSubview(findPreviousButton)
        addSubview(closeButton)
        addSubview(positionIndicatorLabel)
        addSubview(progressBar)
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            searchTextField.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            searchTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            searchTextField.widthAnchor.constraint(equalToConstant: 180),
            
            findButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 8),
            findButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            
            findPreviousButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 8),
            findPreviousButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            
            findNextButton.leadingAnchor.constraint(equalTo: findPreviousButton.trailingAnchor, constant: 8),
            findNextButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            
            positionIndicatorLabel.leadingAnchor.constraint(equalTo: findNextButton.trailingAnchor, constant: 8),
            positionIndicatorLabel.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            
            progressBar.leadingAnchor.constraint(equalTo: findButton.trailingAnchor, constant: 8),
            progressBar.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            closeButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        findButton.addTarget(self, action: #selector(findTapped), for: .touchUpInside)
        findNextButton.addTarget(self, action: #selector(findNextTapped), for: .touchUpInside)
        findPreviousButton.addTarget(self, action: #selector(findPreviousTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    @objc private func findTapped() {
        guard let query = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased(), !query.isEmpty else {
            return
        }
        searchQuery = query
        showNavigationButtons()
        performSearch(query: query)
    }
    
    @objc private func findNextTapped() {
        guard !searchResults.isEmpty else { return }
        searchResultIndex = (searchResultIndex + 1) % searchResults.count
        updateUI()
    }
    
    @objc private func findPreviousTapped() {
        guard !searchResults.isEmpty else { return }
        searchResultIndex = searchResultIndex == 0 ? searchResults.count - 1 : searchResultIndex - 1
        updateUI()
    }
    
    private func showNavigationButtons() {
        findButton.isHidden = true
        findNextButton.isHidden = false
        findPreviousButton.isHidden = false
        positionIndicatorLabel.isHidden = false
    }
    
    private func hideNavigationButtons() {
        findButton.isHidden = false
        findNextButton.isHidden = true
        findPreviousButton.isHidden = true
        positionIndicatorLabel.isHidden = true
    }
    
    private func performSearch(query: String) {
        progressBar.isHidden = false
        progressBar.startAnimating()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Фоновый поиск по структуре проекта (сцены, спрайты, блоки)
            let results: [[Int]] = [] // Заглушка результатов индексов [sceneIndex, spriteIndex, brickIndex]
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.progressBar.stopAnimating()
                self.progressBar.isHidden = true
                self.searchResults = results
                self.searchResultIndex = 0
                self.updateUI()
            }
        }
    }
    
    private func updateUI() {
        guard !searchResults.isEmpty else {
            positionIndicatorLabel.text = "0/0"
            return
        }
        
        let current = searchResults[searchResultIndex]
        positionIndicatorLabel.text = "\(searchResultIndex + 1)/\(searchResults.count)"
        
        if current.count >= 3 {
            delegate?.scriptFinderDidFindResult(sceneIndex: current[0], spriteIndex: current[1], brickIndex: current[2], totalResults: searchResults.count)
        }
    }
    
    public func open() {
        isHidden = false
        searchTextField.becomeFirstResponder()
        delegate?.scriptFinderDidOpen()
    }
    
    @objc public func close() {
        isHidden = true
        searchResults.removeAll()
        searchTextField.text = ""
        searchQuery = ""
        hideNavigationButtons()
        searchTextField.resignFirstResponder()
        delegate?.scriptFinderDidClose()
    }
}
