import Foundation

open class WhenClonedBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: WhenClonedScript(), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var typedScript: WhenClonedScript { return script as! WhenClonedScript }
}
