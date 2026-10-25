import Foundation

open class SpeakAndWaitBrick: FormulaBrick {
    public required init() {
        super.init()
        addAllowedBrickField(.speak)
    }

    public convenience init(_ text: String) {
        self.init(Formula(text))
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.speak, formula)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.textToSpeech)
        super.addRequiredResources(resourcesSet)
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        sequence.addAction(sprite.actionFactory.createSpeakAndWaitAction( sprite, sequence, getFormulaWithBrickField(.speak)))
    }
}
