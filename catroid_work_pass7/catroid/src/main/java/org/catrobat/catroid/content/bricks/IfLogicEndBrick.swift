import Foundation

open class IfLogicEndBrick: BrickBaseType {
    public required init() { super.init() }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {}

    open override var brickID: UUID { return parent?.brickID ?? brickId }
}
