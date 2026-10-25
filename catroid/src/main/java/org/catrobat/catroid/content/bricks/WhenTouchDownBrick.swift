import Foundation

open class WhenTouchDownBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: WhenTouchDownScript(), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var typedScript: WhenTouchDownScript { return script as! WhenTouchDownScript }
}
