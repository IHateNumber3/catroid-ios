import UIKit
import CoreNFC

public class NfcTagsViewController: BaseViewController {
    
    private static let tag = "NfcTagsViewController"
    
    // Менеджер чтения NFC в iOS (CoreNFC)
    private var nfcSession: NFCNDEFReaderSession?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "NFC-метки" // Эквивалент R.string.nfc_activity_title
        
        setupNavigationBar()
        setupNfcListController()
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(handleBackAction)
        )
        
        // Кнопка для сканирования новой NFC-метки (аналог меню)
        let scanButton = UIBarButtonItem(
            image: UIImage(systemName: "wave.3.left.circle"),
            style: .plain,
            target: self,
            action: #selector(startNfcScanning)
        )
        navigationItem.rightBarButtonItem = scanButton
    }
    
    private func setupNfcListController() {
        print("[\(NfcTagsViewController.tag)] Setting up NFC tag list controller...")
        // Добавление дочернего контроллера со списком NFC-меток
    }
    
    @objc private func startNfcScanning() {
        print("[\(NfcTagsViewController.tag)] Starting NFC scan session...")
        // Инициализация и запуск NFCNDEFReaderSession для чтения меток на iOS
    }
}
