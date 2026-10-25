import Foundation

public protocol PhysicsShapeBuilderStrategy {
    func build(pixmap: Pixmap?, scale: Float) -> [B2Shape]?
}
