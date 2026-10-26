import Foundation

open class StitchAction: TemporalAction {
    var sprite: Sprite!

    public override init() { super.init() }

    open override func update(_ delta: Float) {
        sprite.runningStitch.pause()
        var x: Float = sprite.look.xInUserInterfaceDimensionUnit
        var y: Float = sprite.look.yInUserInterfaceDimensionUnit
        StageActivity.stageListener.embroideryPatternManager.addStitchCommand(DSTStitchCommand(x, y, sprite.look.zIndex, sprite, sprite.embroideryThreadColor))
        sprite.runningStitch.setStartCoordinates(x, y)
        sprite.runningStitch.resume()
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
