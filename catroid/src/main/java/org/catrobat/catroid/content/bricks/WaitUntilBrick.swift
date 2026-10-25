import Foundation

open class WaitUntilBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.ifCondition)
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.ifCondition, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createWaitUntilAction(sprite, sequence, getFormulaWithBrickField(.ifCondition)))
    }
}
