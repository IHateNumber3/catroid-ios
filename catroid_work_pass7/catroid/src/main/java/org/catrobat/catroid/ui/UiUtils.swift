import UIKit

public final class UiUtils {
    
    private init() {
        // Предотвращение инициализации утилитного класса
        fatalError("UiUtils cannot be instantiated.")
    }
    
    // MARK: - Drawable / Image Mapping for Menu Items
    
    /// Эквивалент getDrawableForItem / getDrawablesForItems
    public static func imageForItem(named identifier: String) -> UIImage? {
        switch identifier {
        case "backpack_add":
            return UIImage(systemName: "doc.on.clipboard")
        case "copy":
            return UIImage(systemName: "doc.on.doc")
        case "delete":
            return UIImage(systemName: "trash")
        case "edit", "rename":
            return UIImage(systemName: "pencil")
        case "help":
            return UIImage(systemName: "questionmark.circle")
        case "library_add":
            return UIImage(systemName: "folder.badge.plus")
        case "rate_us":
            return UIImage(systemName: "star")
        default:
            return UIImage(systemName: "circle")
        }
    }
    
    // MARK: - Popup Menu Helper
    
    /// Создание контекстного меню или UIMenu для iOS
    public static func createContextMenu(actions: [UIAction]) -> UIMenu {
        return UIMenu(title: "", children: actions)
    }
}

// MARK: - UIViewController & UIView Extensions for Context Retrieval
public extension UIResponder {
    
    /// Поиск родительского контроллера (аналог getActivityFromContextWrapper / getActivityFromView)
    var parentViewController: UIViewController? {
        if let viewController = self as? UIViewController {
            return viewController
        }
        return next?.parentViewController
    }
}
