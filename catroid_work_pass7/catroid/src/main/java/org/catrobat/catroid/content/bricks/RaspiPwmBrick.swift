import Foundation

open class RaspiPwmBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.raspiDigitalPinNumber)
        addAllowedBrickField(.raspiPwmFrequency)
        addAllowedBrickField(.raspiPwmPercentage)
    }

    public convenience init(_ pinNumber: Int, _ pwmFrequency: Double, _ pwmPercentage: Double) {
        self.init(Formula(pinNumber), Formula(pwmFrequency), Formula(pwmPercentage))
    }

    public convenience init(_ pinNumber: Formula, _ pwmFrequency: Formula, _ pwmPercentage: Formula) {
        self.init()
        setFormulaWithBrickField(.raspiDigitalPinNumber, pinNumber)
        setFormulaWithBrickField(.raspiPwmFrequency, pwmFrequency)
        setFormulaWithBrickField(.raspiPwmPercentage, pwmPercentage)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.socketRaspi)
        super.addRequiredResources(resourcesSet)
    }

    open override var defaultBrickField: BrickField { return .raspiDigitalPinNumber }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createSendRaspiPwmValueAction(sprite, sequence, getFormulaWithBrickField(.raspiDigitalPinNumber), getFormulaWithBrickField(.raspiPwmFrequency), getFormulaWithBrickField(.raspiPwmPercentage)))
    }
}
