import Foundation

open class SetTempoBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.tempo)
    }

    public convenience init(_ tempo: Int) {
        self.init(Formula(tempo))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.tempo, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetTempoAction(sprite, sequence, getFormulaWithBrickField(.tempo)))
    }
}
