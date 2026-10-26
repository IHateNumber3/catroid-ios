import Foundation

open class StopRunningStitchBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(ActionFactory.createStopRunningStitchAction(sprite))
    }
}
