import Foundation

open class SetTransparencyBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.transparency)
    }

    public convenience init(_ transparency: Double) {
        self.init(Formula(transparency))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.transparency, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetTransparencyAction(sprite, sequence, getFormulaWithBrickField(.transparency)))
    }
}
