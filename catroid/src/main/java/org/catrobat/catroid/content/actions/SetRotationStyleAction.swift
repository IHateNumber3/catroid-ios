import Foundation

open class SetRotationStyleAction: TemporalAction {
    var sprite: Sprite!
    var mode: Int = 0

    public override init() { super.init() }

    open override func update(_ delta: Float) {
        sprite.look.setRotationMode(mode)
        if mode != Look.rotationStyleLeftRightOnly && sprite.look.isFlipped() {
            sprite.look.lookData?.getTextureRegion().flip(x: true, y: false)
        }
        let orientedLeft = sprite.look.motionDirectionInUserInterfaceDimensionUnit < 0
        if mode == Look.rotationStyleLeftRightOnly && orientedLeft {
            sprite.look.lookData?.getTextureRegion().flip(x: true, y: false)
        }
        sprite.look.setMotionDirectionInUserInterfaceDimensionUnit(sprite.look.motionDirectionInUserInterfaceDimensionUnit)
    }

    public func setSprite(_ sprite: Sprite) { self.sprite = sprite }
    public func setRotationStyle(_ mode: Int) { self.mode = mode }
}
