import Foundation

open class ChangeYByNBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.yPositionChange)
    }

    public convenience init(_ yMovementValue: Int) {
        self.init(Formula(yMovementValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.yPositionChange, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createChangeYByNAction(sprite, sequence, getFormulaWithBrickField(.yPositionChange)))
    }
}
