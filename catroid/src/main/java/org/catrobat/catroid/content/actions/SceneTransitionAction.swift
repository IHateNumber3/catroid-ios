import Foundation

open class SceneTransitionAction: TemporalAction {
    var sceneName: String!
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        guard let targetSceneName = sceneName else { return }
        guard ProjectManager.shared.currentlyPlayingScene?.name != targetSceneName else { return }
        sprite?.releaseAllPointers()
        StageActivity.stageListener?.transitionToScene(targetSceneName)
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
