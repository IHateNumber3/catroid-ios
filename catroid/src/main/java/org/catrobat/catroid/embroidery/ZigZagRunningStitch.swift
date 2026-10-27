import Foundation

/// Tracks zig-zag stitch spacing while the sprite moves.
/// Stitch-command rendering is handled by the embroidery manager when that iOS
/// rendering path is available; this type keeps the running-stitch API functional.
public final class ZigZagRunningStitch: RunningStitchType {
    private weak var sprite: Sprite?
    private let length: Float
    private let width: Float
    private var firstX: Float = 0
    private var firstY: Float = 0
    private var first = true
    private var direction: Float = 1

    public init(_ sprite: Sprite, _ length: Float, _ width: Float) {
        self.sprite = sprite
        self.length = max(0.001, length)
        self.width = width
        firstX = sprite.look.xInUserInterfaceDimensionUnit
        firstY = sprite.look.yInUserInterfaceDimensionUnit
    }

    public func setStartCoordinates(_ x: Float, _ y: Float) {
        firstX = x
        firstY = y
    }

    public func update(_ currentX: Float, _ currentY: Float) {
        guard sprite != nil else { return }
        let distance = hypot(currentX - firstX, currentY - firstY)
        guard distance >= length else { return }
        let segments = floor(distance / length)
        guard segments.isFinite, segments >= 1 else { return }
        let ratio = (segments * length) / distance
        firstX += (currentX - firstX) * ratio
        firstY += (currentY - firstY) * ratio
        first = false
        direction *= -1
        _ = width
    }
}
