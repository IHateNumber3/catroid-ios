import Foundation

open class PenDownBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createPenDownAction(sprite))
    }
}
