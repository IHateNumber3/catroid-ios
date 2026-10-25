import Foundation

open class StopOtherScriptsAction: Action {
    var currentScript: Script!
    var sprite: Sprite!

    public required init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        if !(actor is Look) || actor.getActions() == nil {
            return true
        }
        sprite.releaseAllPointers()
        var look = (Look) actor
        look.stopThreads(getOtherThreads(look))
        return true
    }

    private func getOtherThreads(_ look: Look) -> Array<Action> {
        Array<Action> otherThreads = new Array<>(look.getActions())
        Iterator<Action> it = otherThreads.iterator()
        while it.hasNext() {
            var action = it.next()
            if action is ScriptSequenceAction && (action).getScript( as! ScriptSequenceAction) == currentScript {
                it.remove()
            }
        }
        return otherThreads
    }

    public func setCurrentScript(_ currentScript: Script) {
        self.currentScript = currentScript
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
