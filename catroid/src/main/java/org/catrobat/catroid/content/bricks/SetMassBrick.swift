import Foundation

open class SetMassBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.physicsMass)
    }

    public convenience init(_ mass: Double) {
        self.init(Formula(mass))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.physicsMass, formula)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.physics)
        super.addRequiredResources(resourcesSet)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetMassAction(sprite, sequence, getFormulaWithBrickField(.physicsMass)))
    }
}
