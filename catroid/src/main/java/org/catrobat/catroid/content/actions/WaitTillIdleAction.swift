import Foundation

open class WaitTillIdleAction: Action {
    public required init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        return allActorsIdle()
    }

    private func allActorsIdle() -> Bool {
        var numberOfActors: Int = StageActivity.stageListener.stage.actors.size
        if numberOfActors == 0 {
            return false
        }
        var actorsWithNoEventThreads: Int = 0
        var actorWithOnlyThisEventThread: Int = 0
        for actor in StageActivity.stageListener.stage.actors {
            Array<Action> actions = actor.getActions()
            if actions.size == 0 {
                actorsWithNoEventThreads++
            }
            if actions.size == 1 {
                var sequenceAction = (ScriptSequenceAction) actions.get(0)
                if sequenceAction.getActions().contains(self, true) {
                    actorWithOnlyThisEventThread++
                }
            }
        }
        return numberOfActors == actorsWithNoEventThreads + actorWithOnlyThisEventThread
    }
}
