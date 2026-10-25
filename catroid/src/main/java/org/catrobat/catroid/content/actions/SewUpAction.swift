import Foundation

open class SewUpAction: TemporalAction {
    var sprite: Sprite!
    public static let STEPS: Float = 3.0

    public required init() { super.init() }

    open override func begin() {
        // Конвертація градусів у радіани у Swift
        let degrees = sprite.look.motionDirectionInUserInterfaceDimensionUnit
        let radians = Double(degrees) * .pi / 180.0
        
        sprite.runningStitch.pause()
        
        var x: Float = sprite.look.xInUserInterfaceDimensionUnit
        var y: Float = sprite.look.yInUserInterfaceDimensionUnit
        
        let threadColor = sprite.embroideryThreadColor
        let zIndex = sprite.look.zIndex
        
        if let stageListener = StageManager.shared.stageListener {
            stageListener.embroideryPatternManager.addStitchCommand(
                DSTStitchCommand(x: x, y: y, zIndex: zIndex, sprite: sprite, color: threadColor)
            )
            
            x += SewUpAction.STEPS * Float(sin(radians))
            y += SewUpAction.STEPS * Float(cos(radians))
            stageListener.embroideryPatternManager.addStitchCommand(
                DSTStitchCommand(x: x, y: y, zIndex: zIndex, sprite: sprite, color: threadColor)
            )
            
            x -= SewUpAction.STEPS * Float(sin(radians))
            y -= SewUpAction.STEPS * Float(cos(radians))
            stageListener.embroideryPatternManager.addStitchCommand(
                DSTStitchCommand(x: x, y: y, zIndex: zIndex, sprite: sprite, color: threadColor)
            )
            
            x -= SewUpAction.STEPS * Float(sin(radians))
            y -= SewUpAction.STEPS * Float(cos(radians))
            stageListener.embroideryPatternManager.addStitchCommand(
                DSTStitchCommand(x: x, y: y, zIndex: zIndex, sprite: sprite, color: threadColor)
            )
            
            x += SewUpAction.STEPS * Float(sin(radians))
            y += SewUpAction.STEPS * Float(cos(radians))
            stageListener.embroideryPatternManager.addStitchCommand(
                DSTStitchCommand(x: x, y: y, zIndex: zIndex, sprite: sprite, color: threadColor)
            )
        }
        
        sprite.runningStitch.setStartCoordinates(sprite.look.xInUserInterfaceDimensionUnit, sprite.look.yInUserInterfaceDimensionUnit)
        sprite.runningStitch.resume()
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }

    open override func update(_ delta: Float) {
    }
}
