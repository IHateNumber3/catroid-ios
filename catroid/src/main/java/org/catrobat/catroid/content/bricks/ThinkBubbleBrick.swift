import Foundation

open class ThinkBubbleBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.string)
    }

    public convenience init(_ text: String) {
        self.init(Formula(text))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.string, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createThinkSayBubbleAction(sprite, sequence, new ShowTextUtils.AndroidStringProvider(CatroidApplication.getAppContext()), getFormulaWithBrickField(.string), THINK_BRICK))
    }
}
