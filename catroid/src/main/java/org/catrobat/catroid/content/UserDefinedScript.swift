import Foundation

public final class UserDefinedScript: Script {

    public private(set) var userDefinedBrickID: UUID?
    public var userDefinedBrickInputs: [Any] = []
    public var screenRefresh: Bool = true

    public convenience init(userDefinedBrickID: UUID) {
        self.init()
        self.userDefinedBrickID = userDefinedBrickID
    }

    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil {
            cachedScriptBrick = UserDefinedReceiverBrick(script: self)
        }
        return cachedScriptBrick!
    }

    public override func createEventId(for sprite: Sprite) -> EventId? {
        return UserDefinedBrickEventId(userDefinedBrickID: userDefinedBrickID)
    }

    public func getUserDefinedBrickInput(named name: String) -> UserData? {
        for variable in userDefinedBrickInputs {
            if let data = variable as? UserData, data.name == name {
                return data
            }
        }
        return nil
    }

    public override func copyState(from other: Script) {
        super.copyState(from: other)
        if let o = other as? UserDefinedScript {
            userDefinedBrickID = o.userDefinedBrickID
            userDefinedBrickInputs = o.userDefinedBrickInputs
            screenRefresh = o.screenRefresh
        }
    }
}
