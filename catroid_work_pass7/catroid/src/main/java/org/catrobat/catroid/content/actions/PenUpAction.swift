import Foundation

open class PenUpAction: TemporalAction {
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        if !self.sprite.penConfiguration.isPenDown() {
            return
        }
        self.sprite.penConfiguration.setPenDown(false)
        self.sprite.penConfiguration.addPosition( PointF(self.sprite.look.xInUserInterfaceDimensionUnit, self.sprite.look.yInUserInterfaceDimensionUnit) )
        self.sprite.penConfiguration.incrementQueuesToFinish()
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
