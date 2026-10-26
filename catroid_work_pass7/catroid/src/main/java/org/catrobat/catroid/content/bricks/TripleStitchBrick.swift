import Foundation

open class TripleStitchBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.embroideryLength)
    }

    public convenience init(_ steps: Formula) {
        self.init()
        setFormulaWithBrickField(.embroideryLength, steps)
    }

    open override var defaultBrickField: BrickField { return .embroideryLength }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createTripleStitchAction(sprite, sequence, getFormulaWithBrickField(.embroideryLength)))
    }
}
