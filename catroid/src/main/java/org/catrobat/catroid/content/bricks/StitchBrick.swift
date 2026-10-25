import Foundation

open class StitchBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(ActionFactory.createStitchAction(sprite))
    }
}
