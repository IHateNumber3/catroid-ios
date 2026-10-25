import Foundation

open class SetLookByIndexBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.lookIndex)
    }

    public convenience init(_ index: Int) {
        self.init(Formula(index))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.lookIndex, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetLookByIndexAction(sprite, sequence, getFormulaWithBrickField(.lookIndex)))
    }
}
