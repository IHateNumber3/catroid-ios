import Foundation

open class SetVisibleAction: TemporalAction {
    var sprite: Sprite!
    var visible: Bool = false

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        sprite.look.setLookVisible(visible)
        
        // Використовуємо безпечне розпакування замість перевірки на != nil
        if let stageListener = StageManager.shared.stageListener,
           let actor = stageListener.getBubbleActorForSprite(sprite) {
            actor.setVisible(visible)
        }
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }

    public func setVisible(_ visible: Bool) {
        self.visible = visible
    }
}
