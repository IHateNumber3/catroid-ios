import Foundation

/// Stops all running script actions attached to actors on the current stage.
open class StopAllScriptsAction: Action {
    public required init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        guard let look = actor as? Look else { return true }
        look.stopThreads(look.getActions())
        return true
    }
}
