import Foundation

open class ComeToFrontAction: TemporalAction {
    var sprite: Sprite!

    public override init() { super.init() }

    open override func update(_ delta: Float) {
        List<Sprite> spriteList = ProjectManager.instance.currentProject.spriteListWithClones
        sprite.look.setZIndex(spriteList.size() + Constants.zIndexNumberVirtualLayers - 1)
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
