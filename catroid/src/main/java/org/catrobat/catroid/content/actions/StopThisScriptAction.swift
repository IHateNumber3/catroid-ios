import Foundation

open class StopThisScriptAction: Action {
    var currentScript: Script!

    public required init() { super.init() }

    public func setCurrentScript(_ currentScript: Script) {
        self.currentScript = currentScript
    }

open override func act(_ delta: Float) -> Bool {
        if let look = actor as? Look {
            look.stopThreadWithScript(currentScript)
        }
        return true
    }
}
