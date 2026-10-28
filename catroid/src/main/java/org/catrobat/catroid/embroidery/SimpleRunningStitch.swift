import Foundation

public final class SimpleRunningStitch: RunningStitchType {
    private weak var sprite: Sprite?
    private let length: Float
    private var firstX: Float = 0
    private var firstY: Float = 0
    public init(_ sprite: Sprite, _ length: Int) {
        self.sprite = sprite; self.length = max(0.1, Float(length))
        firstX = sprite.look.xInUserInterfaceDimensionUnit; firstY = sprite.look.yInUserInterfaceDimensionUnit
        EmbroideryPatternManager.shared.addPoint(x: firstX, y: firstY)
    }
    public func setStartCoordinates(_ xStart: Float, _ yStart: Float) { firstX = xStart; firstY = yStart }
    public func update(_ currentX: Float, _ currentY: Float) {
        let dx = currentX - firstX, dy = currentY - firstY
        let distance = hypot(dx, dy)
        guard distance >= length else { return }
        let count = max(1, Int(floor(distance / length)))
        for step in 1...count {
            let t = min(1, Float(step) * length / distance)
            EmbroideryPatternManager.shared.addPoint(x: firstX + dx * t, y: firstY + dy * t)
        }
        let t = min(1, Float(count) * length / distance)
        firstX += dx * t; firstY += dy * t
    }
}
