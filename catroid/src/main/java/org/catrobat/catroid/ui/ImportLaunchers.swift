import UIKit
import UniformTypeIdentifiers

public protocol ImportLauncher {
    func startActivity(from viewController: UIViewController, requestCode: Int)
}

public class ImportFromPocketPaintLauncher: ImportLauncher {
    private let activity: UIViewController
    
    public init(activity: UIViewController) {
        self.activity = activity
    }
    
    public func getPocketPaintCacheURL() -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("pocket_paint_cache.png")
    }
    
    public func startActivity(from viewController: UIViewController, requestCode: Int) {
        print("[ImportFromPocketPaintLauncher] Launching external drawing tool/editor...")
        // В iOS интеграция с внешним редактором через Custom URL Scheme или открытие UIImagePickerController
    }
}

public class ImportFromFileLauncher: NSObject, ImportLauncher, UIDocumentPickerDelegate {
    private weak var viewController: UIViewController?
    private var requestCode: Int = 0
    private let allowedTypes: [UTType]
    
    public init(types: [UTType] = [.image]) {
        self.allowedTypes = types
    }
    
    public func startActivity(from viewController: UIViewController, requestCode: Int) {
        self.viewController = viewController
        self.requestCode = requestCode
        
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: allowedTypes, asCopy: true)
        documentPicker.delegate = self
        viewController.present(documentPicker, animated: true, completion: nil)
    }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        print("[ImportFromFileLauncher] Selected file at: \(url)")
        // Передача выбранного URL обратно в родительский контроллер
    }
}

public class ImportFromCameraLauncher: NSObject, ImportLauncher, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private weak var viewController: UIViewController?
    private var requestCode: Int = 0
    
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func startActivity(from viewController: UIViewController, requestCode: Int) {
        self.viewController = viewController
        self.requestCode = requestCode
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            viewController.present(imagePicker, animated: true, completion: nil)
        } else {
            print("[ImportFromCameraLauncher] Camera is not available.")
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            print("[ImportFromCameraLauncher] Captured image successfully: \(image)")
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
