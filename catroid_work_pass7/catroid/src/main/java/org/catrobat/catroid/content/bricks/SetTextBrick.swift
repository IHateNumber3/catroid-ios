import Foundation

open class SetTextBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.xDestination)
        addAllowedBrickField(.yDestination)
        addAllowedBrickField(.string)
    }

    public convenience init(_ xDestinationValue: Int, _ yDestinationValue: Int, _ text: String) {
        self.init(Formula(xDestinationValue), Formula(yDestinationValue), Formula(text))
    }

    public convenience init(_ xDestination: Formula, _ yDestination: Formula, _ text: Formula) {
        self.init()
        setFormulaWithBrickField(.xDestination, xDestination)
        setFormulaWithBrickField(.yDestination, yDestination)
        setFormulaWithBrickField(.string, text)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetTextAction(sprite, sequence, getFormulaWithBrickField(.xDestination), getFormulaWithBrickField(.yDestination), getFormulaWithBrickField(.string)))
    }
}
