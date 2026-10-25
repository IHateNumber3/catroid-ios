import Foundation

open class ChangeColorByNBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.colorChange)
    }

    public convenience init(_ changeColorValue: Double) {
        self.init(Formula(changeColorValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.colorChange, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createChangeColorByNAction(sprite, sequence, getFormulaWithBrickField(.colorChange)))
    }
}
