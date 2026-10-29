import Foundation

open class SetPenSizeBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.penSize)
    }

    public convenience init(_ penSize: Double) {
        self.init(Formula(penSize))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.penSize, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetPenSizeAction(sprite, sequence, getFormulaWithBrickField(.penSize)))
    }
}
