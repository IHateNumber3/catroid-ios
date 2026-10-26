import Foundation

open class StopRunningStitchAction: TemporalAction {
    var sprite: Sprite!

    public override init() { super.init() }

    open override func update(_ delta: Float) {
        sprite.runningStitch.deactivate()
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
