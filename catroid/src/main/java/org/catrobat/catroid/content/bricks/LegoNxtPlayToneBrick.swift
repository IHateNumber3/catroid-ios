import Foundation

open class LegoNxtPlayToneBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.legoNxtFrequency)
        addAllowedBrickField(.legoNxtDurationInSeconds)
    }

    public convenience init(_ frequencyValue: Double, _ durationValue: Double) {
        self.init(Formula(frequencyValue), Formula(durationValue))
    }

    public convenience init(_ frequencyFormula: Formula, _ durationFormula: Formula) {
        self.init()
        setFormulaWithBrickField(.legoNxtFrequency, frequencyFormula)
        setFormulaWithBrickField(.legoNxtDurationInSeconds, durationFormula)
    }

    open override var defaultBrickField: BrickField { return .legoNxtDurationInSeconds }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.bluetoothLegoNxt)
        super.addRequiredResources(resourcesSet)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createLegoNxtPlayToneAction(sprite, sequence, getFormulaWithBrickField(.legoNxtFrequency), getFormulaWithBrickField(.legoNxtDurationInSeconds)))
    }
}
