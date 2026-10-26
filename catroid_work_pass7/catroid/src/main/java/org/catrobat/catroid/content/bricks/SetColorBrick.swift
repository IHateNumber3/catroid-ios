import Foundation

open class SetColorBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.color)
    }

    public convenience init(_ color: Double) {
        self.init(Formula(color))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.color, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetColorAction(sprite, sequence, getFormulaWithBrickField(.color)))
    }
}
