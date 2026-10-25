import Foundation

open class PointToAction: TemporalAction {
    var sprite: Sprite!
    var pointedSprite: Sprite!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        if pointedSprite == nil || !ProjectManager.instance.currentlyPlayingScene.spriteList.contains(pointedSprite) {
            return
        }
        var spriteXPosition: Float = sprite.look.xInUserInterfaceDimensionUnit
        var spriteYPosition: Float = sprite.look.yInUserInterfaceDimensionUnit
        var pointedSpriteXPosition: Float = pointedSprite.look.xInUserInterfaceDimensionUnit
        var pointedSpriteYPosition: Float = pointedSprite.look.yInUserInterfaceDimensionUnit
        var rotationDegrees: Double
        if spriteXPosition == pointedSpriteXPosition && spriteYPosition == pointedSpriteYPosition {
            rotationDegrees = 90
        } else if spriteXPosition == pointedSpriteXPosition {
            if spriteYPosition < pointedSpriteYPosition {
                rotationDegrees = 0
            } else {
                rotationDegrees = 180
            }
        } else if spriteYPosition == pointedSpriteYPosition {
            if spriteXPosition < pointedSpriteXPosition {
                rotationDegrees = 90
            } else {
                rotationDegrees = -90
            }
        } else {
            rotationDegrees = 90 - Math.toDegrees(Math.atan2(pointedSpriteYPosition - spriteYPosition, pointedSpriteXPosition - spriteXPosition))
        }
        if sprite.look is PhysicsLook {
            (sprite.look as! PhysicsLook).setFlippedByDirection(Float(rotationDegrees))
        }
        sprite.look.setMotionDirectionInUserInterfaceDimensionUnit(Float(rotationDegrees))
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }

    public func setPointedSprite(_ pointedSprite: Sprite) {
        self.pointedSprite = pointedSprite
    }
}
