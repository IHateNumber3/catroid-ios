import Foundation

open class TurnLeftBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.turnLeftDegrees)
    }

    public convenience init(_ degreesValue: Double) {
        self.init(Formula(degreesValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        addAllowedBrickField(.turnLeftDegrees)
        setFormulaWithBrickField(.turnLeftDegrees, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createTurnLeftAction(sprite, sequence, getFormulaWithBrickField(.turnLeftDegrees)))
    }
}
