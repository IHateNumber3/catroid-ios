import Foundation

open class StopAllSoundsBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createStopAllSoundsAction())
    }
}
