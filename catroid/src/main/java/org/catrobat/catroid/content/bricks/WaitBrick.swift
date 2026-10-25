import Foundation

open class WaitBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.timeToWaitInSeconds)
    }

    public convenience init(_ timeToWaitInMillisecondsValue: Int) {
        self.init(Formula(Double(timeToWaitInMillisecondsValue) / 1000.0))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.timeToWaitInSeconds, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createWaitAction(sprite, sequence, getFormulaWithBrickField(.timeToWaitInSeconds)))
    }
}
