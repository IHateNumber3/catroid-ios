import Foundation

open class StopThisScriptAction: Action {
    var currentScript: Script!

    public override init() { super.init() }

    public func setCurrentScript(_ currentScript: Script) {
        self.currentScript = currentScript
    }

    open override func act(_ delta: Float) -> Bool {
        if actor is Look {
            (actor as! Look).stopThreadWithScript(currentScript)
        }
        return true
    }
}
