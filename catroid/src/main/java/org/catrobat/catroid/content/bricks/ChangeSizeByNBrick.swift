import Foundation

open class ChangeSizeByNBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.sizeChange)
    }

    public convenience init(_ sizeValue: Double) {
        self.init(Formula(sizeValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.sizeChange, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createChangeSizeByNAction(sprite, sequence, getFormulaWithBrickField(.sizeChange)))
    }
}
