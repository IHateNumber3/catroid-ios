import Foundation

open class StopOtherScriptsAction: Action {
    var currentScript: Script!
    var sprite: Sprite!

    public required override init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        guard let look = actor as? Look else { return true }
        sprite?.releaseAllPointers()
        look.stopThreads(getOtherThreads(look))
        return true
    }

    private func getOtherThreads(_ look: Look) -> [Action] {
        look.getActions().filter { action in
            guard let sequence = action as? ScriptSequenceAction else { return true }
            return sequence.script !== currentScript
        }
    }

    public func setCurrentScript(_ currentScript: Script) { self.currentScript = currentScript }
    public func setSprite(_ sprite: Sprite) { self.sprite = sprite }
}
