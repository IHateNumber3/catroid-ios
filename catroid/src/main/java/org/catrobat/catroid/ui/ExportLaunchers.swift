import UIKit

public protocol ExportLauncher {
    func startActivity(from viewController: UIViewController)
}

public class ExportEmbroideryFileLauncher: ExportLauncher {
    
    private let fileURL: URL
    
    public init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    public func startActivity(from viewController: UIViewController) {
        // Использование UIActivityViewController для шаринга файла вышивки (аналог Android ACTION_CHOOSER)
        let activityViewController = UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )
        
        // Настройка для iPad (предотвращение краха на планшетах)
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
}

public class ExportSVGFileLauncher: ExportLauncher {
    
    private let fileURL: URL
    
    public init(fileURL: URL) {
        self.fileURL = fileURL
    }
    
    public func getShareActivityController() -> UIActivityViewController {
        return UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )
    }
    
    public func startActivity(from viewController: UIViewController) {
        let activityVC = getShareActivityController()
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(activityVC, animated: true, completion: nil)
    }
}
