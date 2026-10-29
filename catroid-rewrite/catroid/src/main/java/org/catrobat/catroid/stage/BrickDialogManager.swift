import UIKit
import SpriteKit

public enum DialogType {
    case askDialog
    case webAccessDialog
}

public class BrickDialogManager {
    
    private weak var stageViewController: StageViewController?
    private var openDialogs: [UIAlertController] = []
    
    public init(stageViewController: StageViewController) {
        self.stageViewController = stageViewController
    }
    
    public func dialogIsShowing() -> Bool {
        return !openDialogs.isEmpty
    }
    
    public func dismissAllDialogs() {
        for dialog in openDialogs {
            dialog.dismiss(animated: false)
        }
        openDialogs.removeAll()
    }
    
    public func showDialog(type: DialogType, action: Any, content: String) {
        guard let viewController = stageViewController else { return }
        
        let alert: UIAlertController
        switch type {
        case .askDialog:
            alert = createAskDialog(content: content, action: action)
        case .webAccessDialog:
            alert = createWebAccessDialog(url: content, action: action)
        }
        
        openDialog(alert, in: viewController)
    }
    
    private func openDialog(_ dialog: UIAlertController, in viewController: UIViewController) {
        // Приостанавливаем сцену при открытии диалога (аналог StageLifeCycleController.stagePause)
        // StageLifeCycleController.stagePause(for: stageViewController)
        
        openDialogs.append(dialog)
        
        DispatchQueue.main.async {
            viewController.present(dialog, animated: true, completion: nil)
        }
    }
    
    // MARK: - Создание диалога ввода текста (Ask)
    private func createAskDialog(content: String, action: Any) -> UIAlertController {
        let alert = UIAlertController(title: content, message: "Введите ответ:", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Ответ..."
        }
        
        let submitAction = UIAlertAction(title: "ОК", style: .default) { [weak self] _ in
            let answer = alert.textFields?.first?.text ?? ""
            // Передаем ответ в AskAction
            // (action as? AskAction)?.setAnswerText(answer)
            self?.closeDialog(alert)
        }
        
        alert.addAction(submitAction)
        return alert
    }
    
    // MARK: - Создание диалога веб-запроса (Web Access)
    private func createWebAccessDialog(url: String, action: Any) -> UIAlertController {
        let message = "Сцена пытается отправить веб-запрос на:\n\(url)\nРазрешить доступ?"
        let alert = UIAlertController(title: "Веб-доступ", message: message, preferredStyle: .alert)
        
        let onceAction = UIAlertAction(title: "Один раз", style: .default) { [weak self] _ in
            // (action as? WebAction)?.grantPermission()
            self?.closeDialog(alert)
        }
        
        let alwaysAction = UIAlertAction(title: "Всегда", style: .default) { [weak self] _ in
            // Логика добавления в доверенные домены и разрешение
            self?.closeDialog(alert)
        }
        
        let denyAction = UIAlertAction(title: "Запретить", style: .destructive) { [weak self] _ in
            // (action as? WebAction)?.denyPermission()
            self?.closeDialog(alert)
        }
        
        alert.addAction(onceAction)
        alert.addAction(alwaysAction)
        alert.addAction(denyAction)
        
        return alert
    }
    
    private func closeDialog(_ dialog: UIAlertController) {
        if let index = openDialogs.firstIndex(of: dialog) {
            openDialogs.remove(at: index)
        }
        // Возобновляем сцену, если больше нет открытых диалогов
        if openDialogs.isEmpty, let viewController = stageViewController {
            // StageLifeCycleController.stageResume(for: viewController)
        }
    }
}
