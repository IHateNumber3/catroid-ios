import Foundation

public final class TripleRunningStitch: RunningStitchType {
    private weak var sprite: Sprite?
    private let steps: Float
    private var startX: Float = 0
    private var startY: Float = 0
    public init(_ sprite: Sprite, _ steps: Int) {
        self.sprite = sprite; self.steps = max(0.1, Float(steps))
        startX = sprite.look.xInUserInterfaceDimensionUnit; startY = sprite.look.yInUserInterfaceDimensionUnit
        EmbroideryPatternManager.shared.addPoint(x: startX, y: startY)
    }
    public func setStartCoordinates(_ x: Float, _ y: Float) { startX = x; startY = y }
    public func update(_ currentX: Float, _ currentY: Float) {
        guard sprite != nil else { return }
        let dx = currentX - startX, dy = currentY - startY, distance = hypot(dx, dy)
        guard distance >= steps else { return }
        let count = max(1, Int(floor(distance / steps)))
        let endX = startX + dx * (Float(count) * steps / distance)
        let endY = startY + dy * (Float(count) * steps / distance)
        for i in 1...count {
            let t = Float(i) / Float(count)
            let x = startX + (endX - startX) * t, y = startY + (endY - startY) * t
            EmbroideryPatternManager.shared.addPoint(x: x, y: y)
            EmbroideryPatternManager.shared.addPoint(x: startX + (endX - startX) * (1 - t), y: startY + (endY - startY) * (1 - t))
            EmbroideryPatternManager.shared.addPoint(x: x, y: y)
        }
        startX = endX; startY = endY
    }
}
