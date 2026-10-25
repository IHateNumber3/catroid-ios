import Foundation

open class VibrationBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.vibrateDurationInSeconds)
    }

    public convenience init(_ vibrateDurationInSeconds: Double) {
        self.init(Formula(vibrateDurationInSeconds))
    }

    public convenience init(_ vibrateDurationInSecondsFormula: Formula) {
        self.init()
        setFormulaWithBrickField(.vibrateDurationInSeconds, vibrateDurationInSecondsFormula)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.vibration)
        super.addRequiredResources(resourcesSet)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createVibrateAction(sprite, sequence, getFormulaWithBrickField(.vibrateDurationInSeconds)))
    }
}
