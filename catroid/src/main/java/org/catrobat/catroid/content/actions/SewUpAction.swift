import Foundation

open class SewUpAction: TemporalAction {
    var sprite: Sprite!
    public static let STEPS: Int = 3

    public required init() { super.init() }

    open override func begin() {
        guard let sprite = sprite else { return }
        sprite.runningStitch.pause()
        sprite.runningStitch.setStartCoordinates(sprite.look.xInUserInterfaceDimensionUnit, sprite.look.yInUserInterfaceDimensionUnit)
        sprite.runningStitch.resume()
    }

    public func setSprite(_ sprite: Sprite) { self.sprite = sprite }
    open override func update(_ delta: Float) {}
}
