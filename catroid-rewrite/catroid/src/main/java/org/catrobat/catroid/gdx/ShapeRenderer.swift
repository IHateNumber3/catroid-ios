import Foundation
import UIKit

/// Замена gdx OrthographicCamera (только то, что нужно рисованию линий)
public final class Camera {
    public var position = CGPoint.zero
    public var viewportWidth: Float = 0
    public var viewportHeight: Float = 0
    public init() {}
}

/// Замена ShapeRenderer (Filled): рисует в CGContext слоя пера/плоттера.
public final class ShapeRenderer {
    public var context: CGContext?
    public var color: UIColor = .white
    private var drawing = false

    public init() {}

    public func begin() { drawing = true; context?.setFillColor(color.cgColor) }
    public func end() { drawing = false }

    public func circle(_ x: Float, _ y: Float, _ radius: Float) {
        guard let c = context else { return }
        c.setFillColor(color.cgColor)
        c.fillEllipse(in: CGRect(x: CGFloat(x - radius), y: CGFloat(y - radius),
                                 width: CGFloat(radius * 2), height: CGFloat(radius * 2)))
    }

    /// Линия толщиной `width` как заливаемый прямоугольник (rectLine в libGDX)
    public func rectLine(_ x1: Float, _ y1: Float, _ x2: Float, _ y2: Float, _ width: Float) {
        guard let c = context else { return }
        let dx = x2 - x1, dy = y2 - y1
        let len = (dx * dx + dy * dy).squareRoot()
        if len == 0 { return }
        let nx = -dy / len * width / 2, ny = dx / len * width / 2
        c.setFillColor(color.cgColor)
        c.beginPath()
        c.move(to: CGPoint(x: CGFloat(x1 + nx), y: CGFloat(y1 + ny)))
        c.addLine(to: CGPoint(x: CGFloat(x2 + nx), y: CGFloat(y2 + ny)))
        c.addLine(to: CGPoint(x: CGFloat(x2 - nx), y: CGFloat(y2 - ny)))
        c.addLine(to: CGPoint(x: CGFloat(x1 - nx), y: CGFloat(y1 - ny)))
        c.closePath()
        c.fillPath()
    }
}
