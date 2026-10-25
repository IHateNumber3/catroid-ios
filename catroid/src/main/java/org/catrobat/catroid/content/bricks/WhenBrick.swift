import Foundation

open class WhenBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: WhenScript(), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var typedScript: WhenScript { return script as! WhenScript }
}
