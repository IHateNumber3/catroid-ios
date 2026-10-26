import Foundation

open class WhenRaspiPinChangedBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: RaspiInterruptScript(), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var typedScript: RaspiInterruptScript { return script as! RaspiInterruptScript }
}
