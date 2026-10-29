import Foundation

open class WhenGamepadButtonBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: WhenGamepadButtonScript(), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var typedScript: WhenGamepadButtonScript { return script as! WhenGamepadButtonScript }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.castRequired)
    }
}
