import Foundation

open class StitchAction: TemporalAction {
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        sprite.runningStitch.pause()
        let x: Float = sprite.look.xInUserInterfaceDimensionUnit
        let y: Float = sprite.look.yInUserInterfaceDimensionUnit
        if let stageListener = StageManager.shared.stageListener {
            stageListener.embroideryPatternManager.addStitchCommand(DSTStitchCommand(x, y, sprite.look.zIndex, sprite, sprite.embroideryThreadColor))
        }
        sprite.runningStitch.setStartCoordinates(x, y)
        sprite.runningStitch.resume()
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
