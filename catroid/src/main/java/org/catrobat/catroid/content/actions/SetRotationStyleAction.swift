import Foundation

open class SetRotationStyleAction: TemporalAction {
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        sprite.look.setRotationMode(mode)
        if mode != Look.rotationStyleLeftRightOnly && sprite.look.isFlipped() {
            sprite.look.lookData.getTextureRegion().flip(true, false)
        }
        var orientedLeft: Bool = sprite.look.motionDirectionInUserInterfaceDimensionUnit < 0
        if mode == Look.rotationStyleLeftRightOnly && orientedLeft {
            sprite.look.lookData.getTextureRegion().flip(true, false)
        }
        sprite.look.setMotionDirectionInUserInterfaceDimensionUnit(sprite.look.motionDirectionInUserInterfaceDimensionUnit)
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }

    public func setRotationStyle() {
        self.mode = mode
    }
}
