import Foundation

open class ClearGraphicEffectAction: TemporalAction {
    var sprite: Sprite!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        sprite.look.setBrightnessInUserInterfaceDimensionUnit(100.0)
        sprite.look.setTransparencyInUserInterfaceDimensionUnit(0.0)
        sprite.look.setColorInUserInterfaceDimensionUnit(0.0)
        sprite.look.hasParticleEffect = false
        sprite.look.clearParticleEffect()
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
