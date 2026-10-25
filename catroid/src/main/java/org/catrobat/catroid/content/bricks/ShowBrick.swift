import Foundation

open class ShowBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createShowAction(sprite))
    }
}
