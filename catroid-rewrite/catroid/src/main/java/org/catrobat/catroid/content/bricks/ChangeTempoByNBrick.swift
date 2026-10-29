import Foundation

open class ChangeTempoByNBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.tempoChange)
    }

    public convenience init(_ changeTempoValue: Int) {
        self.init(Formula(changeTempoValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.tempoChange, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createChangeTempoAction(sprite, sequence, getFormulaWithBrickField(.tempoChange)))
    }
}
