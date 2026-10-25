import Foundation

open class AssertEqualsBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.assertEqualsActual)
        addAllowedBrickField(.assertEqualsExpected)
    }

    open override var defaultBrickField: BrickField { return .assertEqualsActual }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createAssertEqualsAction(sprite, sequence, getFormulaWithBrickField(.assertEqualsActual), getFormulaWithBrickField(.assertEqualsExpected), getPositionInformation()))
    }
}
