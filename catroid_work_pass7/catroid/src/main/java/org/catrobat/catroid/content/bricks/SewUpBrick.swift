import Foundation

open class SewUpBrick: FormulaBrick {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createSewUpAction(sprite))
    }
}
