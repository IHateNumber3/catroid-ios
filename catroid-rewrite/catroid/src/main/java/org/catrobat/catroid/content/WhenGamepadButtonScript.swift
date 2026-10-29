import Foundation

public final class WhenGamepadButtonScript: Script {

    public var action: String?

    public convenience init(action: String?) {
        self.init()
        self.action = action
    }

    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil {
            cachedScriptBrick = WhenGamepadButtonBrick(script: self)
        }
        return cachedScriptBrick!
    }

    public override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(BrickResource.castRequired)
        super.addRequiredResources(resourcesSet)
    }

    public override func createEventId(for sprite: Sprite) -> EventId? {
        return GamepadEventId(action: action)
    }

    public override func copyState(from other: Script) {
        super.copyState(from: other)
        if let o = other as? WhenGamepadButtonScript {
            action = o.action
        }
    }
}
