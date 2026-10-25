import Foundation

open class SetVolumeToBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.volume)
    }

    public convenience init(_ volume: Double) {
        self.init(Formula(volume))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.volume, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createSetVolumeToAction(sprite, sequence, getFormulaWithBrickField(.volume)))
    }
}
