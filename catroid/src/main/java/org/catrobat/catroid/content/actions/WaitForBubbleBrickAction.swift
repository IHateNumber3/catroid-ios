import Foundation

open class WaitForBubbleBrickAction: WaitAction {
    public required init() { super.init() }
    open override func end() {
        if StageListener.shared.getBubbleActorForSprite(scope.sprite) != nil {
            StageListener.shared.removeBubbleActorForSprite(scope.sprite)
        }
    }
}
