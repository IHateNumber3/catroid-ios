import Foundation

public final class ZigZagRunningStitch: RunningStitchType {
    private weak var sprite: Sprite?
    private let length: Float
    private let width: Float
    private var firstX: Float = 0
    private var firstY: Float = 0
    private var direction: Float = 1
    public init(_ sprite: Sprite, _ length: Float, _ width: Float) {
        self.sprite = sprite; self.length = max(0.1, length); self.width = width
        firstX = sprite.look.xInUserInterfaceDimensionUnit; firstY = sprite.look.yInUserInterfaceDimensionUnit
        EmbroideryPatternManager.shared.addPoint(x: firstX, y: firstY)
    }
    public func setStartCoordinates(_ x: Float, _ y: Float) { firstX = x; firstY = y }
    public func update(_ currentX: Float, _ currentY: Float) {
        guard sprite != nil else { return }
        let dx = currentX - firstX, dy = currentY - firstY, distance = hypot(dx, dy)
        guard distance >= length else { return }
        let count = max(1, Int(floor(distance / length)))
        let unitX = dx / distance, unitY = dy / distance
        let perpX = -unitY * width / 2, perpY = unitX * width / 2
        for i in 1...count {
            let t = min(1, Float(i) * length / distance)
            let centerX = firstX + dx * t, centerY = firstY + dy * t
            EmbroideryPatternManager.shared.addPoint(x: centerX + perpX * direction, y: centerY + perpY * direction)
            direction *= -1
        }
        let t = min(1, Float(count) * length / distance)
        firstX += dx * t; firstY += dy * t
    }
}
