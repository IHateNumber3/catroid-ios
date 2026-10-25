import Foundation

open class ClearGraphicEffectBrick: BrickBaseType {
    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createClearGraphicEffectAction(sprite))
    }
}
