import UIKit

public struct ViewUtils {
    private static let waitTime: TimeInterval = 0.1 // 100 миллисекунд
}

public extension UIView {
    
    /// Показывает виртуальную клавиатуру с небольшой задержкой (эквивалент showKeyboard)
    func showKeyboard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + ViewUtils.waitTime) { [weak self] in
            self?.becomeFirstResponder()
        }
    }
    
    /// Скрывает виртуальную клавиатуру (эквивалент hideKeyboard)
    func hideKeyboard() {
        self.resignFirstResponder()
    }
}
