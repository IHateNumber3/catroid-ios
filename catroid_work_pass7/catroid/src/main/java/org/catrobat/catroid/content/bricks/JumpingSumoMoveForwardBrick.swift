import Foundation

open class JumpingSumoMoveForwardBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.jumpingSumoTimeToDriveInSeconds)
        addAllowedBrickField(.jumpingSumoSpeed)
    }

    public convenience init(_ durationInMilliseconds: Int, _ powerInPercent: Int) {
        self.init(Formula(Double(durationInMilliseconds) / 1000.0), Formula(powerInPercent))
    }

    public convenience init(_ durationInSeconds: Formula, _ powerInPercent: Formula) {
        self.init()
        setFormulaWithBrickField(.jumpingSumoTimeToDriveInSeconds, durationInSeconds)
        setFormulaWithBrickField(.jumpingSumoSpeed, powerInPercent)
    }

    open override var defaultBrickField: BrickField { return .jumpingSumoTimeToDriveInSeconds }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
    }
}
