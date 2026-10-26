import Foundation

open class WaitForBubbleBrickAction: WaitAction {
    public override init() { super.init() }

    open override func end() {
        if StageActivity.stageListener.getBubbleActorForSprite(scope.sprite) != nil {
            StageActivity.stageListener.removeBubbleActorForSprite(scope.sprite)
        }
    }
}
