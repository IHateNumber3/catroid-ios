import Foundation

open class RaspiSendDigitalValueBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.raspiDigitalPinNumber)
        addAllowedBrickField(.raspiDigitalPinValue)
    }

    public convenience init(_ pinNumber: Int, _ pinValue: Int) {
        self.init(Formula(pinNumber), Formula(pinValue))
    }

    public convenience init(_ pinNumber: Formula, _ pinValue: Formula) {
        self.init()
        setFormulaWithBrickField(.raspiDigitalPinNumber, pinNumber)
        setFormulaWithBrickField(.raspiDigitalPinValue, pinValue)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.socketRaspi)
        super.addRequiredResources(resourcesSet)
    }

    open override var defaultBrickField: BrickField { return .raspiDigitalPinNumber }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createSendDigitalRaspiValueAction(sprite, sequence, getFormulaWithBrickField(.raspiDigitalPinNumber), getFormulaWithBrickField(.raspiDigitalPinValue)))
    }
}
