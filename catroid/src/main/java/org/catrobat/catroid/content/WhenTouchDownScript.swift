import Foundation

public final class WhenTouchDownScript: Script {

    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil {
            cachedScriptBrick = WhenTouchDownBrick(script: self)
        }
        return cachedScriptBrick!
    }

    public override func createEventId(for sprite: Sprite) -> EventId? {
        return EventId(EventId.tapBackground)
    }
}
