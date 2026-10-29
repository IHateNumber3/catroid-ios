import UIKit

public class BrickLayout: UIView {
    
    public static let horizontal = 0
    public static let vertical = 1
    
    private let minTextFieldWidthDp: CGFloat = 100.0
    
    public var horizontalSpacing: CGFloat = 0
    public var verticalSpacing: CGFloat = 0
    public var orientation: Int = 0
    public var debugDraw: Bool = false
    public var userBrick: Bool = false
    public var usePng: Bool = false
    
    private var layoutDirectionMultiplier: CGFloat = 1.0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: Codable) {
        super.init(coder: coder)
        setupLayout()
    }

    private func setupLayout() {
        // Определение направления текста (RTL / LTR)
        if UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft {
            layoutDirectionMultiplier = -1.0
        }
    }

    // MARK: - Layout & Measurement (Эквивалент onMeasure и onLayout в Android)
    
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        // Кастомный расчет размеров контейнера блоков
        let boundingSize = CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude)
        var totalHeight: CGFloat = 0
        var currentLineWidth: CGFloat = 0
        var currentLineHeight: CGFloat = 0
        
        for subview in subviews {
            if subview.isHidden { continue }
            
            let fittingSize = subview.sizeThatFits(boundingSize)
            
            if currentLineWidth + fittingSize.width > size.width {
                totalHeight += currentLineHeight + verticalSpacing
                currentLineWidth = fittingSize.width + horizontalSpacing
                currentLineHeight = fittingSize.height
            } else {
                currentLineWidth += fittingSize.width + horizontalSpacing
                currentLineHeight = max(currentLineHeight, fittingSize.height)
            }
        }
        totalHeight += currentLineHeight
        return CGSize(width: size.width, height: totalHeight)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let boundsWidth = bounds.width
        var currentX: CGFloat = paddingLeft()
        var currentY: CGFloat = safeAreaInsets.top
        var currentLineHeight: CGFloat = 0
        
        for subview in subviews {
            if subview.isHidden { continue }
            
            let fittingSize = subview.sizeThatFits(bounds.size)
            
            // Проверка на перенос строки
            if currentX + fittingSize.width > boundsWidth - paddingRight() {
                currentX = paddingLeft()
                currentY += currentLineHeight + verticalSpacing
                currentLineHeight = 0
            }
            
            subview.frame = CGRect(x: currentX, y: currentY, width: fittingSize.width, height: fittingSize.height)
            
            currentX += fittingSize.width + horizontalSpacing
            currentLineHeight = max(currentLineHeight, fittingSize.height)
        }
    }
    
    private func paddingLeft() -> CGFloat {
        if !usePng {
            return bounds.width * 0.14 + safeAreaInsets.left
        } else {
            return safeAreaInsets.left
        }
    }
    
    private func paddingRight() -> CGFloat {
        return safeAreaInsets.right
    }

    // MARK: - Debug Drawing
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if debugDraw {
            drawDebugInfo()
        }
    }

    private func drawDebugInfo() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(1.0)
        
        // Отрисовка отладочных рамок и линий для блоков
        for subview in subviews {
            let frame = subview.frame
            context.stroke(frame)
        }
    }
}
