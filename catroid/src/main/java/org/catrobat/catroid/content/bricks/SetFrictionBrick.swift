import Foundation

open class SetFrictionBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.physicsFriction)
    }

    public convenience init(_ friction: Double) {
        self.init(Formula(friction))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.physicsFriction, formula)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.physics)
        super.addRequiredResources(resourcesSet)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetFrictionAction(sprite, sequence, getFormulaWithBrickField(.physicsFriction)))
    }
}
