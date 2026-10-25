import UIKit

public enum BottomBar {
    
    public static func showBottomBar(in viewController: UIViewController?) {
        guard let view = viewController?.view else { return }
        if let bottomBar = view.viewWithTag(1001) { // Условный тег или аутлет нижней панели
            bottomBar.isHidden = false
        }
    }

    public static func hideBottomBar(in viewController: UIViewController?) {
        guard let view = viewController?.view else { return }
        if let bottomBar = view.viewWithTag(1001) {
            bottomBar.isHidden = true
        }
    }

    public static func showAddButton(in viewController: UIViewController?) {
        guard let view = viewController?.view else { return }
        if let addButton = view.viewWithTag(1002) as? UIButton {
            addButton.isHidden = false
        }
    }

    public static func hideAddButton(in viewController: UIViewController?) {
        guard let view = viewController?.view else { return }
        if let addButton = view.viewWithTag(1002) as? UIButton {
            addButton.isHidden = true
        }
    }

    public static func showPlayButton(in viewController: UIViewController?) {
        guard let view = viewController?.view else { return }
        if let playButton = view.viewWithTag(1003) as? UIButton {
            playButton.isHidden = false
        }
    }

    public static func hidePlayButton(in viewController: UIViewController?) {
        guard let view = viewController?.view else { return }
        if let playButton = view.viewWithTag(1003) as? UIButton {
            playButton.isHidden = true
        }
    }

    public static func showAiAssistButton(in viewController: UIViewController?) {
        guard let view = viewController?.view else { return }
        if let aiButton = view.viewWithTag(1004) as? UIButton {
            aiButton.isHidden = false
        }
    }

    public static func hideAiAssistButton(in viewController: UIViewController?) {
        guard let view = viewController?.view else { return }
        if let aiButton = view.viewWithTag(1004) as? UIButton {
            aiButton.isHidden = true
        }
    }
}
