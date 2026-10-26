import Foundation

open class RaspiIfLogicBeginBrick: IfLogicBeginBrick {

    public required init() { super.init() }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.ifCondition, formula)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        resourcesSet.add(.socketRaspi)
        super.addRequiredResources(resourcesSet)
    }

    open override func createIfAction(_ sprite: Sprite, _ sequence: ScriptSequenceAction,
                                      _ ifSequence: ScriptSequenceAction, _ elseSequence: ScriptSequenceAction) -> Action {
        return sprite.actionFactory.createRaspiIfLogicActionAction(sprite, sequence, getFormulaWithBrickField(.ifCondition),
                                                                   ifSequence, elseSequence)
    }
}
