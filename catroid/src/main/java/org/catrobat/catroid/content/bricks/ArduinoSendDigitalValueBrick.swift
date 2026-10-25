import Foundation

open class ArduinoSendDigitalValueBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.arduinoDigitalPinNumber)
        addAllowedBrickField(.arduinoDigitalPinValue)
    }

    public convenience init(_ pinNumber: Int, _ pinValue: Int) {
        self.init(Formula(pinNumber), Formula(pinValue))
    }

    public convenience init(_ pinNumber: Formula, _ pinValue: Formula) {
        self.init()
        setFormulaWithBrickField(.arduinoDigitalPinNumber, pinNumber)
        setFormulaWithBrickField(.arduinoDigitalPinValue, pinValue)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.bluetoothSensorsArduino)
        super.addRequiredResources(resourcesSet)
    }

    open override var defaultBrickField: BrickField { return .arduinoDigitalPinNumber }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createSendDigitalArduinoValueAction(sprite, sequence, getFormulaWithBrickField(.arduinoDigitalPinNumber), getFormulaWithBrickField(.arduinoDigitalPinValue)))
    }
}
