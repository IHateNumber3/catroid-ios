import Foundation

open class ZigZagStitchBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.zigzagEmbroideryLength)
        addAllowedBrickField(.zigzagEmbroideryWidth)
    }

    public convenience init(_ length: Formula, _ width: Formula) {
        self.init()
        setFormulaWithBrickField(.zigzagEmbroideryLength, length)
        setFormulaWithBrickField(.zigzagEmbroideryWidth, width)
    }

    open override var defaultBrickField: BrickField { return .zigzagEmbroideryLength }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createZigZagStitchAction(sprite, sequence, getFormulaWithBrickField(.zigzagEmbroideryLength), getFormulaWithBrickField(.zigzagEmbroideryWidth)))
    }
}
