import Foundation

open class RepeatBrick: FormulaBrick, CompositeBrick {
    private var endBrickStorage: EndBrick?
    public var nestedBricks: [Brick] = []
    public var secondaryNestedBricks: [Brick] = []
    public var hasSecondaryList: Bool { return false }

    public var endBrick: EndBrick {
        if endBrickStorage == nil { endBrickStorage = EndBrick(parent: self) }
        return endBrickStorage!
    }

    public required init() {
        super.init()
        addAllowedBrickField(.timesToRepeat)
    }

    public convenience init(_ condition: Formula) {
        self.init()
        setFormulaWithBrickField(.timesToRepeat, condition)
    }

    @discardableResult
    public func addBrick(_ brick: Brick) -> Bool {
        nestedBricks.append(brick)
        return true
    }

    open override func setCommentedOut(_ commentedOut: Bool) {
        super.setCommentedOut(commentedOut)
        for brick in nestedBricks { brick.setCommentedOut(commentedOut) }
    }

    open override func copyState(from other: BrickBaseType) {
        super.copyState(from: other)
        endBrickStorage = nil
        nestedBricks = []
        if let o = other as? RepeatBrick {
            for brick in o.nestedBricks { addBrick(brick.clone()) }
        }
    }

    open override func consistsOfMultipleParts() -> Bool { return true }

    open override func getAllParts() -> [Brick] { return [self, endBrick] }

    open override func addToFlatList(_ bricks: inout [Brick]) {
        super.addToFlatList(&bricks)
        for brick in nestedBricks { brick.addToFlatList(&bricks) }
        bricks.append(endBrick)
    }

    open override func setParent(_ parent: Brick?) {
        super.setParent(parent)
        for brick in nestedBricks { brick.setParent(self) }
    }

    open override var dragAndDropTargetList: [Brick] { return nestedBricks }

    open override func removeChild(_ brick: Brick) -> Bool {
        if let i = nestedBricks.firstIndex(where: { $0 === brick }) {
            nestedBricks.remove(at: i)
            return true
        }
        for child in nestedBricks where child.removeChild(brick) { return true }
        return false
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        let loopSequence = ActionFactory.createScriptSequenceAction(sequence.script) as! ScriptSequenceAction
        let isLoopDelay = LoopUtil.checkLoopBrickForLoopDelay(self, sequence.script)
        for brick in nestedBricks where !brick.isCommentedOut {
            brick.addActionToSequence(sprite: sprite, sequence: loopSequence)
        }
        let action = sprite.actionFactory.createRepeatAction(sprite, sequence, getFormulaWithBrickField(.timesToRepeat), loopSequence, isLoopDelay)
        sequence.addAction(action)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        super.addRequiredResources(resourcesSet)
        for brick in nestedBricks { brick.addRequiredResources(resourcesSet) }
    }
}
