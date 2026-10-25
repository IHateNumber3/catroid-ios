import Foundation

open class WaitTillIdleBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createWaitTillIdleAction())
    }
}
