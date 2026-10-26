import Foundation

open class IfLogicBeginBrick: FormulaBrick, CompositeBrick {
    private var elseBrickStorage: ElseBrick?
    private var endBrickStorage: EndBrick?
    public var ifBranchBricks: [Brick] = []
    public var elseBranchBricks: [Brick] = []
    public var hasSecondaryList: Bool { return true }
    public var nestedBricks: [Brick] {
        get { return ifBranchBricks }
        set { ifBranchBricks = newValue }
    }
    public var secondaryNestedBricks: [Brick] {
        get { return elseBranchBricks }
        set { elseBranchBricks = newValue }
    }

    public var elseBrick: ElseBrick {
        if elseBrickStorage == nil { elseBrickStorage = ElseBrick(parent: self) }
        return elseBrickStorage!
    }

    public var endBrick: EndBrick {
        if endBrickStorage == nil { endBrickStorage = EndBrick(parent: self) }
        return endBrickStorage!
    }

    public required init() {
        super.init()
        addAllowedBrickField(.ifCondition)
    }

    public convenience init(_ formula: Formula) {
        self.init()
        setFormulaWithBrickField(.ifCondition, formula)
    }

    @discardableResult
    public func addBrickToIfBranch(_ brick: Brick) -> Bool { ifBranchBricks.append(brick); return true }

    @discardableResult
    public func addBrickToElseBranch(_ brick: Brick) -> Bool { elseBranchBricks.append(brick); return true }

    open override func setCommentedOut(_ commentedOut: Bool) {
        super.setCommentedOut(commentedOut)
        for brick in ifBranchBricks { brick.setCommentedOut(commentedOut) }
        for brick in elseBranchBricks { brick.setCommentedOut(commentedOut) }
    }

    open override func copyState(from other: BrickBaseType) {
        super.copyState(from: other)
        elseBrickStorage = nil
        endBrickStorage = nil
        ifBranchBricks = []
        elseBranchBricks = []
        if let o = other as? IfLogicBeginBrick {
            for brick in o.ifBranchBricks { addBrickToIfBranch(brick.clone()) }
            for brick in o.elseBranchBricks { addBrickToElseBranch(brick.clone()) }
        }
    }

    open override func consistsOfMultipleParts() -> Bool { return true }

    open override func getAllParts() -> [Brick] { return [self, elseBrick, endBrick] }

    open override func addToFlatList(_ bricks: inout [Brick]) {
        super.addToFlatList(&bricks)
        for brick in ifBranchBricks { brick.addToFlatList(&bricks) }
        bricks.append(elseBrick)
        for brick in elseBranchBricks { brick.addToFlatList(&bricks) }
        bricks.append(endBrick)
    }

    open override func setParent(_ parent: Brick?) {
        super.setParent(parent)
        for brick in ifBranchBricks { brick.setParent(self) }
        for brick in elseBranchBricks { brick.setParent(elseBrick) }
    }

    open override var dragAndDropTargetList: [Brick] { return ifBranchBricks }

    open override func removeChild(_ brick: Brick) -> Bool {
        if let i = ifBranchBricks.firstIndex(where: { $0 === brick }) { ifBranchBricks.remove(at: i); return true }
        if let i = elseBranchBricks.firstIndex(where: { $0 === brick }) { elseBranchBricks.remove(at: i); return true }
        for child in ifBranchBricks where child.removeChild(brick) { return true }
        for child in elseBranchBricks where child.removeChild(brick) { return true }
        return false
    }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        let ifSequence = ActionFactory.createScriptSequenceAction(sequence.script) as! ScriptSequenceAction
        let elseSequence = ActionFactory.createScriptSequenceAction(sequence.script) as! ScriptSequenceAction
        for brick in ifBranchBricks where !brick.isCommentedOut {
            brick.addActionToSequence(sprite: sprite, sequence: ifSequence)
        }
        for brick in elseBranchBricks where !brick.isCommentedOut {
            brick.addActionToSequence(sprite: sprite, sequence: elseSequence)
        }
        let action = createIfAction(sprite, sequence, ifSequence, elseSequence)
        sequence.addAction(action)
    }

    /// Переопределяется в RaspiIfLogicBeginBrick
    open func createIfAction(_ sprite: Sprite, _ sequence: ScriptSequenceAction,
                             _ ifSequence: ScriptSequenceAction, _ elseSequence: ScriptSequenceAction) -> Action {
        return sprite.actionFactory.createIfLogicAction(sprite, sequence, getFormulaWithBrickField(.ifCondition),
                                                        ifSequence, elseSequence)
    }

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        super.addRequiredResources(resourcesSet)
        for brick in ifBranchBricks { brick.addRequiredResources(resourcesSet) }
        for brick in elseBranchBricks { brick.addRequiredResources(resourcesSet) }
    }
}
