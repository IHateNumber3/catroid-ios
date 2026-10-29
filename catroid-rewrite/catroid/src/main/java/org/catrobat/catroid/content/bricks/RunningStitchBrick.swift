import Foundation

open class RunningStitchBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.embroideryLength)
    }

    public convenience init(_ length: Formula) {
        self.init()
        setFormulaWithBrickField(.embroideryLength, length)
    }

    open override var defaultBrickField: BrickField { return .embroideryLength }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createRunningStitchAction(sprite, sequence, getFormulaWithBrickField(.embroideryLength)))
    }
}
