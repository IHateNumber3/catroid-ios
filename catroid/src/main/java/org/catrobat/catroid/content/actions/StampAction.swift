import Foundation

open class StampAction: TemporalAction {
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        self.sprite.penConfiguration.setStamp(true)
        StageManager.shared.stageListener?.penActor.stampToFrameBuffer()
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
