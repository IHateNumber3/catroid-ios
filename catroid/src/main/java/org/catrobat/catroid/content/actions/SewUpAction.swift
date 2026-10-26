import Foundation

open class SewUpAction: TemporalAction {
    var sprite: Sprite!
    public static let STEPS: Int = 3

    public required init() { super.init() }

    open override func begin() {
        var radians: Double = Math.toRadians(sprite.look.motionDirectionInUserInterfaceDimensionUnit)
        sprite.runningStitch.pause()
        var x: Float = sprite.look.xInUserInterfaceDimensionUnit
        var y: Float = sprite.look.yInUserInterfaceDimensionUnit
        StageActivity.stageListener.embroideryPatternManager.addStitchCommand(DSTStitchCommand(x, y, sprite.look.zIndex, sprite, sprite.embroideryThreadColor))
        x += SewUpAction.STEPS * Math.sin(radians)
        y += SewUpAction.STEPS * Math.cos(radians)
        StageActivity.stageListener.embroideryPatternManager.addStitchCommand(DSTStitchCommand(x, y, sprite.look.zIndex, sprite, sprite.embroideryThreadColor))
        x -= SewUpAction.STEPS * Math.sin(radians)
        y -= SewUpAction.STEPS * Math.cos(radians)
        StageActivity.stageListener.embroideryPatternManager.addStitchCommand(DSTStitchCommand(x, y, sprite.look.zIndex, sprite, sprite.embroideryThreadColor))
        x -= SewUpAction.STEPS * Math.sin(radians)
        y -= SewUpAction.STEPS * Math.cos(radians)
        StageActivity.stageListener.embroideryPatternManager.addStitchCommand(DSTStitchCommand(x, y, sprite.look.zIndex, sprite, sprite.embroideryThreadColor))
        x += SewUpAction.STEPS * Math.sin(radians)
        y += SewUpAction.STEPS * Math.cos(radians)
        StageActivity.stageListener.embroideryPatternManager.addStitchCommand(DSTStitchCommand(x, y, sprite.look.zIndex, sprite, sprite.embroideryThreadColor))
        sprite.runningStitch.setStartCoordinates(sprite.look.xInUserInterfaceDimensionUnit, sprite.look.yInUserInterfaceDimensionUnit)
        sprite.runningStitch.resume()
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }

    open override func update(_ delta: Float) {
    }
}
