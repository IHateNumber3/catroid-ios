import Foundation

open class WaitTillIdleAction: Action {
    public required init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        let actors = StageListener.shared.stage.actors
        guard !actors.isEmpty else { return false }

        var actorsWithNoEventThreads = 0
        var actorsWithOnlyThisEventThread = 0
        for actor in actors {
            let actions = actor.actions
            if actions.isEmpty {
                actorsWithNoEventThreads += 1
            } else if actions.count == 1,
                      let sequence = actions[0] as? ScriptSequenceAction,
                      sequence.getActions().contains(where: { $0 === self }) {
                actorsWithOnlyThisEventThread += 1
            }
        }
        return actors.count == actorsWithNoEventThreads + actorsWithOnlyThisEventThread
    }
}
