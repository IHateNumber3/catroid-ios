import Foundation

open class IfOnEdgeBounceBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createIfOnEdgeBounceAction(sprite))
    }
}
