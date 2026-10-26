import Foundation

open class PenDownAction: TemporalAction {
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        if self.sprite.penConfiguration.isPenDown() {
            return
        }
        self.sprite.penConfiguration.addQueue()
        self.sprite.penConfiguration.addPosition( PointF(self.sprite.look.xInUserInterfaceDimensionUnit, self.sprite.look.yInUserInterfaceDimensionUnit) )
        self.sprite.penConfiguration.setPenDown(true)
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
