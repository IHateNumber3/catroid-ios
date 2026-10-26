import Foundation

open class PointInDirectionBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.degrees)
    }

    public convenience init(_ direction: Double) {
        self.init(Formula(direction))
    }

    public convenience init(_ direction: Formula) {
        self.init()
        setFormulaWithBrickField(.degrees, direction)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory .createPointInDirectionAction(sprite, sequence, getFormulaWithBrickField(.degrees)))
    }
}
