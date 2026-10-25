import Foundation

open class WhenStartedBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: StartScript(), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var typedScript: StartScript { return script as! StartScript }
}
