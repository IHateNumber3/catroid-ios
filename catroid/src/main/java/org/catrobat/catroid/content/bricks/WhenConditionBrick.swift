import Foundation

/// Event brick for a condition becoming true.
open class WhenConditionBrick: FormulaBrick, ScriptBrick {
    private var ownedScript: WhenConditionScript?

    public required init() {
        let script = WhenConditionScript()
        ownedScript = script
        super.init()
        addAllowedBrickField(.ifCondition)
        script.setScriptBrick(self)
    }

    public init(script: WhenConditionScript) {
        ownedScript = script
        super.init()
        addAllowedBrickField(.ifCondition)
        formulaMap = script.formulaMap
        script.setScriptBrick(self)
        commentedOut = script.commentedOut
    }

    open override var script: Script? { ownedScript }
    public var typedScript: WhenConditionScript { ownedScript ?? WhenConditionScript() }
    public var conditionFormula: Formula { getFormulaWithBrickField(.ifCondition) }

    open override func copyState(from other: BrickBaseType) {
        super.copyState(from: other)
        guard let other = other as? WhenConditionBrick, let original = other.ownedScript else { return }
        let copied = original.clone() as? WhenConditionScript ?? WhenConditionScript()
        ownedScript = copied
        copied.setScriptBrick(self)
        formulaMap = copied.formulaMap
    }

    open override func addToFlatList(_ bricks: inout [Brick]) {
        super.addToFlatList(&bricks)
        for brick in ownedScript?.brickList ?? [] { brick.addToFlatList(&bricks) }
    }

    open override var dragAndDropTargetList: [Brick] { ownedScript?.brickList ?? [] }
    open override func setCommentedOut(_ commentedOut: Bool) {
        super.setCommentedOut(commentedOut)
        ownedScript?.setCommentedOut(commentedOut)
    }
}
