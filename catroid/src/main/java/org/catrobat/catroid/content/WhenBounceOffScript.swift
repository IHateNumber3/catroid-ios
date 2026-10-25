import Foundation

public final class WhenBounceOffScript: Script {

    private var nameStorage: String = ""
    private var spriteToBounceOff: Sprite? // transient

    public convenience init(spriteToBounceOffName: String?) {
        self.init()
        self.nameStorage = spriteToBounceOffName ?? ""
    }

    /// nil, если имя пустое (как в Java getSpriteToBounceOffName).
    public var spriteToBounceOffName: String? {
        get { return nameStorage.isEmpty ? nil : nameStorage }
        set {
            nameStorage = newValue ?? ""
            updateSpriteToCollideWith(scene: ProjectManager.shared.currentlyEditedScene)
        }
    }

    public func updateSpriteToCollideWith(scene: Scene) {
        guard !nameStorage.isEmpty else { return }
        spriteToBounceOff = scene.getSprite(nameStorage)
        if spriteToBounceOff == nil {
            nameStorage = ""
        }
    }

    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil {
            cachedScriptBrick = WhenBounceOffBrick(script: self)
        }
        return cachedScriptBrick!
    }

    public override func createEventId(for sprite: Sprite) -> EventId? {
        return BounceOffEventId(sprite: sprite, spriteToBounceOff: spriteToBounceOff)
    }

    public override func copyState(from other: Script) {
        super.copyState(from: other)
        if let o = other as? WhenBounceOffScript {
            nameStorage = o.nameStorage
            spriteToBounceOff = o.spriteToBounceOff
        }
    }
}
