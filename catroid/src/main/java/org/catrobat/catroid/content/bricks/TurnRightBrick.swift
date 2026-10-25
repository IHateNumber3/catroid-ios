import Foundation

open class TurnRightBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.turnRightDegrees)
    }

    public convenience init(_ degreesValue: Double) {
        self.init(Formula(degreesValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        addAllowedBrickField(.turnRightDegrees)
        setFormulaWithBrickField(.turnRightDegrees, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createTurnRightAction(sprite, sequence, getFormulaWithBrickField(.turnRightDegrees)))
    }
}
