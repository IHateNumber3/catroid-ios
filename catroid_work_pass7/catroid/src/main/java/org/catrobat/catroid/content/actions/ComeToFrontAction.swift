import Foundation

open class ComeToFrontAction: TemporalAction {
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        let spriteList = ProjectManager.shared.currentProject?.spriteListWithClones ?? []
        sprite.look.setZIndex(spriteList.count + Constants.zIndexNumberVirtualLayers - 1)
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
