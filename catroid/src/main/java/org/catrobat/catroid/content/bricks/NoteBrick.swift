import Foundation

open class NoteBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.note)
    }

    public convenience init(_ note: String) {
        self.init(Formula(note))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.note, formula)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
    }
}
