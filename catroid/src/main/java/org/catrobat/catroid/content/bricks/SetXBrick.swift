import Foundation

open class SetXBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.xPosition)
    }

    public convenience init(_ xPositionValue: Int) {
        self.init(Formula(xPositionValue))
    }

    public convenience init(_ xPosition: Formula) {
        self.init()
        setFormulaWithBrickField(.xPosition, xPosition)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetXAction(sprite, sequence, getFormulaWithBrickField(.xPosition)))
    }
}
