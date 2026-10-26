import Foundation

public protocol RunningStitchType: AnyObject {
    func update(_ currentX: Float, _ currentY: Float)
    func setStartCoordinates(_ xStart: Float, _ yStart: Float)
}

public final class RunningStitch {
    private weak var sprite: Sprite?
    private var running = false
    private var type: RunningStitchType?

    public init() {}

    public func activateStitching(sprite: Sprite?, type: RunningStitchType?) {
        if let sprite = sprite, let type = type {
            self.sprite = sprite
            self.type = type
            running = true
        }
    }

    public func update() {
        if running, let sprite = sprite {
            type?.update(sprite.look.xInUserInterfaceDimensionUnit, sprite.look.yInUserInterfaceDimensionUnit)
        }
    }

    public func setStartCoordinates(_ x: Float, _ y: Float) { type?.setStartCoordinates(x, y) }
    public func pause() { running = false }
    public func resume() { if type != nil { running = true } }
    public func deactivate() { running = false; type = nil; sprite = nil }
    public var isRunning: Bool { return running }
}
