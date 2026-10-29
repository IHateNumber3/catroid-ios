import Foundation

/// Common base for Catroid loop actions. The small delay prevents tight loops
/// from consuming the entire frame, matching the Android implementation.
open class LoopAction: Action {
    public var isLoopDelay = true
    open var currentTime: Float = 0
    public static let loopDelay: Float = 0.02

    public func isLoopDelayNeeded() -> Bool {
        currentTime < Self.loopDelay && isLoopDelay
    }

    open func delegate(_ delta: Float) -> Bool {
        return true
    }

    open override func act(_ delta: Float) -> Bool {
        return delegate(delta)
    }

    open override func restart() {
        currentTime = 0
        super.restart()
    }
}
