import Foundation

public final class WhenBackgroundChangesScript: Script {

    public var look: LookData?

    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil {
            cachedScriptBrick = WhenBackgroundChangesBrick(script: self)
        }
        return cachedScriptBrick!
    }

    public override func createEventId(for sprite: Sprite) -> EventId? {
        let background = ProjectManager.shared.currentlyPlayingScene.backgroundSprite
        return SetLookEventId(sprite: background, look: look)
    }

    public override func copyState(from other: Script) {
        super.copyState(from: other)
        if let o = other as? WhenBackgroundChangesScript {
            look = o.look
        }
    }
}
