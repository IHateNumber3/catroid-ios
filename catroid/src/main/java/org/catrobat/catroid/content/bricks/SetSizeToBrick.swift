import Foundation

open class SetSizeToBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.size)
    }

    public convenience init(_ size: Double) {
        self.init(Formula(size))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.size, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createSetSizeToAction(sprite, sequence, getFormulaWithBrickField(.size)))
    }
}
