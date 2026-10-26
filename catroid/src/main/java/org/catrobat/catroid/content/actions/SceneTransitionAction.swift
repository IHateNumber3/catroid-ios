import Foundation

open class SceneTransitionAction: TemporalAction {
    var sceneName: String!
    var sprite: Sprite!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        if sceneName != nil && !ProjectManager.instance.currentlyPlayingScene.name.equals(sceneName) {
            sprite.releaseAllPointers()
            StageActivity.stageListener.transitionToScene(sceneName)
        }
    }

    open override func reset() {
        super.reset()
        sceneName = nil
    }

    public func setScene(_ sceneName: String) {
        self.sceneName = sceneName
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
