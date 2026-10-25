import Foundation

open class ChangeBrightnessByNBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.brightnessChange)
    }

    public convenience init(_ changeBrightnessValue: Double) {
        self.init(Formula(changeBrightnessValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.brightnessChange, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createChangeBrightnessByNAction(sprite, sequence, getFormulaWithBrickField(.brightnessChange)))
    }
}
