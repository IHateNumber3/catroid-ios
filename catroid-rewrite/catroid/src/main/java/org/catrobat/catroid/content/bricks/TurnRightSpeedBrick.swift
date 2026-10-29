import Foundation

open class TurnRightSpeedBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.physicsTurnRightSpeed)
    }

    public convenience init(_ degreesPerSecond: Double) {
        self.init(Formula(degreesPerSecond))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.physicsTurnRightSpeed, formula)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.physics)
        super.addRequiredResources(resourcesSet)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createTurnRightSpeedAction(sprite, sequence, getFormulaWithBrickField(.physicsTurnRightSpeed)))
    }
}
