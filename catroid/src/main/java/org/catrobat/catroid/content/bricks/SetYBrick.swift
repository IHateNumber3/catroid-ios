import Foundation

open class SetYBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.yPosition)
    }

    public convenience init(_ yPositionValue: Int) {
        self.init(Formula(yPositionValue))
    }

    public convenience init(_ yPosition: Formula) {
        self.init()
        setFormulaWithBrickField(.yPosition, yPosition)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetYAction(sprite, sequence, getFormulaWithBrickField(.yPosition)))
    }
}
