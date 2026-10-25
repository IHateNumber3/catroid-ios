import Foundation

open class EmptyEventBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: EmptyScript(), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var typedScript: EmptyScript { return script as! EmptyScript }
}
