import Foundation

open class ClearBackgroundBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createClearBackgroundAction())
    }
}
