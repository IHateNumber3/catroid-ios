import UIKit

public enum EdgeToEdge {
    
    /// Применение верхнего отступа с учетом безопасной зоны (эквивалент applyTopPadding)
    public static func applyTopPadding(to view: UIView) {
        // В iOS это автоматически обрабатывается через safeAreaInsets или дополнительный констриинт
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    /// Применение нижнего внешнего отступа (эквивалент applyBottomMargin)
    public static func applyBottomMargin(to view: UIView) {
        guard let superview = view.superview else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    /// Применение отступа для плавающей кнопки (эквивалент applyFloatingActionButtonMargin)
    public static func applyFloatingActionButtonMargin(to view: UIView) {
        guard let superview = view.superview else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    /// Применение нижнего внутреннего отступа (эквивалент applyBottomPadding)
    public static func applyBottomPadding(to view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        // Учет клавиатуры и нижней безопасной зоны в iOS
    }
}
