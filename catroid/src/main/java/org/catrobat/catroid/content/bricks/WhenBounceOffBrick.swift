import Foundation

open class WhenBounceOffBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: WhenBounceOffScript(), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var typedScript: WhenBounceOffScript { return script as! WhenBounceOffScript }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.physics)
    }
}
