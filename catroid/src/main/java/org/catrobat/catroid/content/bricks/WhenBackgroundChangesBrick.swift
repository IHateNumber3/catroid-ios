import Foundation

/// Event brick fired when the scene background changes.
open class WhenBackgroundChangesBrick: ScriptBrickBaseType {
    private var ownedScript: WhenBackgroundChangesScript?

    public required init() {
        let script = WhenBackgroundChangesScript()
        ownedScript = script
        super.init(script: script, ownsScript: true)
    }

    public init(script: WhenBackgroundChangesScript) {
        ownedScript = script
        super.init(script: script, ownsScript: false)
    }

    open override var script: Script? { ownedScript }
    public var look: LookData? {
        get { ownedScript?.look }
        set { ownedScript?.look = newValue }
    }

    open override func copyState(from other: BrickBaseType) {
        super.copyState(from: other)
        if let other = other as? WhenBackgroundChangesBrick {
            let copied = (other.ownedScript?.clone() as? WhenBackgroundChangesScript) ?? WhenBackgroundChangesScript()
            ownedScript = copied
            copied.setScriptBrick(self)
        }
    }
}
