import Foundation

open class ThinkForBubbleBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.string)
        addAllowedBrickField(.durationInSeconds)
    }

    public convenience init(_ text: String, _ durationInSecondsValue: Float) {
        self.init(Formula(text), Formula(durationInSecondsValue))
    }

    public convenience init(_ text: Formula, _ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.string, text)
        setFormulaWithBrickField(.durationInSeconds, formula)
    }

    open override var defaultBrickField: BrickField { return .string }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createThinkSayForBubbleAction(sprite, sequence, new ShowTextUtils.AndroidStringProvider(CatroidApplication.getAppContext()), getFormulaWithBrickField(.string), THINK_BRICK))
        sequence.addAction(sprite.actionFactory.createWaitForBubbleBrickAction(sprite, sequence, getFormulaWithBrickField(.durationInSeconds)))
    }
}
