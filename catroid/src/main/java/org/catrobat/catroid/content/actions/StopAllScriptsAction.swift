import Foundation

open class StopAllScriptsAction: Action {
    public required init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        Array<Actor> stageActors = StageActivity.stageListener.stage.actors
        for actor in stageActors {
            if actor is Look {
                var look = (Look) actor
                look.stopThreads(look.getActions())
            }
        }
        return true
    }
}
