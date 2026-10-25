import Foundation

open class JumpingSumoRotateRightBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.jumpingSumoRotate)
    }

    public convenience init(_ degree: Double) {
        self.init(Formula(degree))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.jumpingSumoRotate, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
    }
}
