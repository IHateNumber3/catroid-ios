import Foundation

open class GoToTouchPositionAction: TemporalAction {
    var sprite: Sprite!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        var touchIndex: Int = TouchUtil.lastTouchIndex
        var x: Float = TouchUtil.getX(touchIndex)
        var y: Float = TouchUtil.getY(touchIndex)
        sprite.look.setPositionInUserInterfaceDimensionUnit(x, y)
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
