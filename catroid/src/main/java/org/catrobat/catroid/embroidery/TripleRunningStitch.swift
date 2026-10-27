import Foundation

/// Triple-running embroidery stitch. The current iOS port does not yet expose
/// the embroidery pattern manager, so this preserves state/protocol compatibility
/// without pretending to emit drawable stitch commands.
public final class TripleRunningStitch: RunningStitchType {
    private weak var sprite: Sprite?
    private let steps: Int
    private var startX: Float = 0
    private var startY: Float = 0

    public init(_ sprite: Sprite, _ steps: Int) {
        self.sprite = sprite
        self.steps = max(1, steps)
        self.startX = sprite.look.xInUserInterfaceDimensionUnit
        self.startY = sprite.look.yInUserInterfaceDimensionUnit
    }

    public func setStartCoordinates(_ x: Float, _ y: Float) {
        startX = x
        startY = y
    }

    public func update(_ currentX: Float, _ currentY: Float) {
        let dx = currentX - startX
        let dy = currentY - startY
        if hypot(dx, dy) >= Float(steps) {
            startX = currentX
            startY = currentY
        }
    }
}
