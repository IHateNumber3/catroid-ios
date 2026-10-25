import Foundation

open class StopAllScriptsAction: Action {
    public required init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        if let stageListener = StageManager.shared.stageListener {
            let stageActors = stageListener.stage.actors
            for actor in stageActors {
                if let look = actor as? Look {
                    look.stopThreads(look.getActions())
                }
            }
        }
        return true
    }
}
