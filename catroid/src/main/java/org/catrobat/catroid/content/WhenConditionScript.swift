import Foundation

public final class WhenConditionScript: Script {

    public private(set) var formulaMap = ConcurrentFormulaHashMap()

    public required init() {
        super.init()
        formulaMap.putIfAbsent(BrickField.ifCondition, Formula(0))
    }

    public convenience init(formula: Formula) {
        self.init()
        formulaMap.replace(BrickField.ifCondition, formula)
    }

    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil {
            cachedScriptBrick = WhenConditionBrick(script: self)
        }
        return cachedScriptBrick!
    }

    public override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        for formula in formulaMap.values {
            formula.addRequiredResources(resourcesSet)
        }
        // Как в Java: без проверки commentedOut
        for brick in brickList {
            brick.addRequiredResources(resourcesSet)
        }
    }

    public override func createEventId(for sprite: Sprite) -> EventId? {
        guard let brick = scriptBrick as? WhenConditionBrick else { return nil }
        return WhenConditionEventId(formula: brick.conditionFormula)
    }

    public override func copyState(from other: Script) {
        super.copyState(from: other)
        if let o = other as? WhenConditionScript {
            formulaMap = o.formulaMap.clone()
        }
    }
}
