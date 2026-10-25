import Foundation

open class TurnLeftSpeedBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.physicsTurnLeftSpeed)
    }

    public convenience init(_ degreesPerSecond: Double) {
        self.init(Formula(degreesPerSecond))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.physicsTurnLeftSpeed, formula)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.physics)
        super.addRequiredResources(resourcesSet)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createTurnLeftSpeedAction(sprite, sequence, getFormulaWithBrickField(.physicsTurnLeftSpeed)))
    }
}
