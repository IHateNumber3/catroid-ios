import Foundation

open class LegoEv3PlayToneBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.legoEv3Frequency)
        addAllowedBrickField(.legoEv3DurationInSeconds)
        addAllowedBrickField(.legoEv3Volume)
    }

    public convenience init(_ frequencyValue: Double, _ durationValue: Double, _ volumeValue: Double) {
        self.init(Formula(frequencyValue), Formula(durationValue), Formula(volumeValue))
    }

    public convenience init(_ frequencyFormula: Formula, _ durationFormula: Formula, _ volumeFormula: Formula) {
        self.init()
        setFormulaWithBrickField(.legoEv3Frequency, frequencyFormula)
        setFormulaWithBrickField(.legoEv3DurationInSeconds, durationFormula)
        setFormulaWithBrickField(.legoEv3Volume, volumeFormula)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(BLUETOOTH_LEGO_EV3)
        super.addRequiredResources(resourcesSet)
    }

    open override var defaultBrickField: BrickField { return .legoEv3DurationInSeconds }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createLegoEv3PlayToneAction(sprite, sequence, getFormulaWithBrickField(.legoEv3Frequency), getFormulaWithBrickField(.legoEv3DurationInSeconds), getFormulaWithBrickField(.legoEv3Volume)))
    }
}
