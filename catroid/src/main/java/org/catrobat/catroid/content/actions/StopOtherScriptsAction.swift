import Foundation

open class StopOtherScriptsAction: Action {
    var currentScript: Script!
    var sprite: Sprite!

    public required init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        guard let look = actor as? Look else {
            return true
        }
        
        sprite.releaseAllPointers()
        look.stopThreads(getOtherThreads(look))
        return true
    }

    private func getOtherThreads(_ look: Look) -> [Action] {
        guard let actions = look.getActions() else {
            return []
        }
        
        // Використовуємо ідіоматичний фільтр замість Java Iterator
        return actions.filter { action in
            if let sequenceAction = action as? ScriptSequenceAction {
                return sequenceAction.script !== currentScript
            }
            return true
        }
    }

    public func setCurrentScript(_ currentScript: Script) {
        self.currentScript = currentScript
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }
}
