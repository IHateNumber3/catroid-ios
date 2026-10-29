import UIKit

public struct ProjectUtils {
    
    private static let tag = "ProjectUtils"
    
    /// Проверка проекта на наличие подозрительных блоков
    public static func shouldDisplaySuspiciousBricksWarning(for project: Project) -> Bool {
        var allBricks: [Brick] = []
        
        for scene in project.sceneList {
            for sprite in scene.spriteList {
                allBricks.append(contentsOf: sprite.getListAllBricks())
            }
        }
        
        return allBricks.containsSuspiciousBricks()
    }
    
    /// Показ предупреждения о подозрительных блоках один раз для скачанных проектов
    public static func showWarningForSuspiciousBricksOnce(in viewController: UIViewController, for project: Project) {
        let defaults = UserDefaults.standard
        let preferenceKey = "approved_list_file_key"
        
        guard let projectUrl = project.xmlHeader.remixParentsUrlString, !projectUrl.isEmpty else {
            return
        }
        
        let isDownloadedProject = !projectUrl.isEmpty
        let hasShownBefore = defaults.string(forKey: projectUrl) != nil
        
        if isDownloadedProject && shouldDisplaySuspiciousBricksWarning(for: project) && !hasShownBefore {
            let alert = UIAlertController(
                title: "Предупреждение безопасности",
                message: "Этот проект содержит потенциально небезопасные блоки (прослушивание сети и веб-запросы). Будьте осторожны.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                defaults.set(projectUrl, forKey: projectUrl)
            })
            
            DispatchQueue.main.async {
                viewController.present(alert, animated: true, completion: nil)
            }
        } else if isDownloadedProject {
            defaults.set(projectUrl, forKey: projectUrl)
        }
    }
}

// MARK: - Extensions for Bricks Analysis
public extension Array where Element == Brick {
    func containsSuspiciousBricks() -> Bool {
        let hasStartListening = contains { $0 is StartListeningBrick }
        let hasWebRequest = contains { $0 is WebRequestBrick || $0 is BackgroundRequestBrick || $0 is LookRequestBrick }
        return hasStartListening && hasWebRequest
    }
}

public extension Sprite {
    func getListAllBricks() -> [Brick] {
        var bricks: [Brick] = []
        for brick in allBricks {
            bricks.append(brick)
            // Рекурсивный сбор вложенных блоков (аналог switch(brick) в Kotlin)
            bricks.append(contentsOf: brick.nestedBricks)
            if let secondaryNested = brick.secondaryNestedBricks {
                bricks.append(contentsOf: secondaryNested)
            }
        }
        return bricks
    }
}
