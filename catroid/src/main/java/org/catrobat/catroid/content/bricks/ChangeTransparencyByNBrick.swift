import Foundation

open class ChangeTransparencyByNBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.transparencyChange)
    }

    public convenience init(_ changeTransparencyValue: Double) {
        self.init(Formula(changeTransparencyValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.transparencyChange, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createChangeTransparencyByNAction(sprite, sequence, getFormulaWithBrickField(.transparencyChange)))
    }
}
