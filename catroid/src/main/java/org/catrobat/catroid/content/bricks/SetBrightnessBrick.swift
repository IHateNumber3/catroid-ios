import Foundation

open class SetBrightnessBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.brightness)
    }

    public convenience init(_ brightness: Double) {
        self.init(Formula(brightness))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.brightness, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createSetBrightnessAction(sprite, sequence, getFormulaWithBrickField(.brightness)))
    }
}
