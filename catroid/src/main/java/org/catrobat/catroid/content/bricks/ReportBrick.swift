import Foundation

open class ReportBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.reportBrick)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createReportAction(sprite, SequenceAction(), sequence.script, getFormulaWithBrickField(.reportBrick)))
    }
}
