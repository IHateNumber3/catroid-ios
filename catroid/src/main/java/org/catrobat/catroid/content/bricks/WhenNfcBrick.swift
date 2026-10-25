import Foundation

open class WhenNfcBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: WhenNfcScript(), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var typedScript: WhenNfcScript { return script as! WhenNfcScript }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.nfcAdapter)
    }
}
