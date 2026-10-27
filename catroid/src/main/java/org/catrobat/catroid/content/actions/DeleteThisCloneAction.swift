import Foundation

open class DeleteThisCloneAction: TemporalAction {
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        if sprite == nil {
            return
        }
        StageActivity.stageListener?.removeClonedSpriteFromStage(sprite)
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
