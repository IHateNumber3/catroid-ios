import Foundation

/// Base class for actions that initialize once and then remain active until finished.
/// Mirrors Catroid's Android AsynchronousAction without depending on Android or libGDX.
open class AsynchronousAction: Action {
    public internal(set) var initialized = false

    open func initialize() {}
    open func isFinished() -> Bool { true }

    open override func act(_ delta: Float) -> Bool {
        if !initialized {
            initialize()
            initialized = true
        }
        return isFinished()
    }

    open override func restart() {
        initialized = false
    }
}
