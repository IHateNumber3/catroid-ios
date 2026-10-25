import Foundation

open class DroneMoveForwardBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.droneTimeToFlyInSeconds)
        addAllowedBrickField(.dronePowerInPercent)
    }

    public convenience init(_ durationInMilliseconds: Int, _ powerInPercent: Int) {
        self.init(Formula(Double(durationInMilliseconds) / 1000.0), Formula(powerInPercent))
    }

    public convenience init(_ durationInSeconds: Formula, _ powerInPercent: Formula) {
        self.init()
        setFormulaWithBrickField(.droneTimeToFlyInSeconds, durationInSeconds)
        setFormulaWithBrickField(.dronePowerInPercent, powerInPercent)
    }

    open override var defaultBrickField: BrickField { return .droneTimeToFlyInSeconds }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
    }
}
