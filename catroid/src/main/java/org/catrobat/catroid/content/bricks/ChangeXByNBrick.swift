import Foundation

open class ChangeXByNBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.xPositionChange)
    }

    public convenience init(_ xMovementValue: Int) {
        self.init(Formula(xMovementValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.xPositionChange, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createChangeXByNAction(sprite, sequence, getFormulaWithBrickField(.xPositionChange)))
    }
}
