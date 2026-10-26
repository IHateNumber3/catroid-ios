import Foundation

/// Runtime-only receiver brick for user-defined scripts (UI controls are not part of the iOS core).
public final class UserDefinedReceiverBrick: ScriptBrickBaseType {
    public var spinnerSelection: Int = 0
    public required init() { super.init() }
    public convenience init(script: UserDefinedScript) { self.init(script: script as Script) }
    public init(script: Script) { super.init(script: script) }
}
