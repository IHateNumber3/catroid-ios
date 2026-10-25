import Foundation

open class GoNStepsBackBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.steps)
    }

    public convenience init(_ steps: Int) {
        self.init(Formula(steps))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.steps, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createGoNStepsBackAction(sprite, sequence, getFormulaWithBrickField(.steps)))
    }
}
