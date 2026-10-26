import Foundation

open class DeleteThisCloneBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createDeleteThisCloneAction(sprite))
    }
}
