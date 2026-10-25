import Foundation

open class ChangeVolumeByNBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.volumeChange)
    }

    public convenience init(_ changeVolumeValue: Double) {
        self.init(Formula(changeVolumeValue))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.volumeChange, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createChangeVolumeByNAction(sprite, sequence, getFormulaWithBrickField(.volumeChange)))
    }
}
