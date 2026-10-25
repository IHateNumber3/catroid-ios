import Foundation

open class SetVisibleAction: TemporalAction {
    var sprite: Sprite!
    var visible: Bool = false

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        sprite.look.setLookVisible(visible)
        if StageActivity.stageListener != nil {
            var actor = StageActivity.stageListener.getBubbleActorForSprite(sprite)
            if actor != nil {
                actor.setVisible(visible)
            }
        }
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }

    public func setVisible(_ visible: Bool) {
        self.visible = visible
    }
}
