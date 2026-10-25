import Foundation

open class ComeToFrontBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createComeToFrontAction(sprite))
    }
}
