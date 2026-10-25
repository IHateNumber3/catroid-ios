import Foundation

open class PauseForBeatsBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.beatsToPause)
    }

    public convenience init(_ pausedBeats: Float) {
        self.init(Formula(pausedBeats))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.beatsToPause, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createPauseForBeatsAction(sprite, sequence, getFormulaWithBrickField(.beatsToPause)))
    }
}
