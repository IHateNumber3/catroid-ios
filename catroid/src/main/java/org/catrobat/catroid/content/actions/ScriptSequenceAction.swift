import Foundation

public class ScriptSequenceAction: SequenceAction {

    public let script: Script

    public init(script: Script) {
        self.script = script
        super.init()
    }

    public convenience init(_ actions: Action..., script: Script) {
        self.init(script: script)
        actions.forEach { addAction($0) }
    }

    public func clone() -> ScriptSequenceAction {
        return cloneAndChangeScript(script)
    }

    public func cloneAndChangeScript(_ script: Script) -> ScriptSequenceAction {
        let copy = ActionFactory.createScriptSequenceAction(script) as! ScriptSequenceAction
        for child in getActions() {
            copy.addAction(child)
        }
        return copy
    }
}
