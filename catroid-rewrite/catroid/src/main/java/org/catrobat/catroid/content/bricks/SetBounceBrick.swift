import Foundation

open class SetBounceBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.physicsBounceFactor)
    }

    public convenience init(_ bounceFactor: Double) {
        self.init(Formula(bounceFactor))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.physicsBounceFactor, formula)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.physics)
        super.addRequiredResources(resourcesSet)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createSetBounceFactorAction(sprite, sequence, getFormulaWithBrickField(.physicsBounceFactor)))
    }
}
