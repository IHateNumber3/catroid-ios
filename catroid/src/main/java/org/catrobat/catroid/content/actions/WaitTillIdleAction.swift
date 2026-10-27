import Foundation

open class WaitTillIdleAction: Action {
    public required override init() { super.init() }
    open override func act(_ delta: Float) -> Bool {
        let actors = StageListener.shared.stage.actors
        guard !actors.isEmpty else { return false }
        for actor in actors {
            let actions = actor.actions
            if actions.isEmpty { continue }
            if actions.count == 1,
               let sequence = actions.first as? ScriptSequenceAction,
               sequence.getActions().contains(where: { $0 === self }) { continue }
            return false
        }
        return true
    }
}
