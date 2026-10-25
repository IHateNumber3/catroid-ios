import Foundation

/// Брик-разделитель «иначе» (IfLogicBeginBrick.ElseBrick / PhiroIfLogicBeginBrick.ElseBrick)
public final class ElseBrick: BrickBaseType {

    public required init() { super.init() }

    public init(parent ifBrick: BrickBaseType) {
        super.init()
        setParent(ifBrick)
    }

    public override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {}
    public override var isCommentedOut: Bool { return parent?.isCommentedOut ?? false }
    public override func consistsOfMultipleParts() -> Bool { return true }
    public override func getAllParts() -> [Brick] { return parent?.getAllParts() ?? [] }
    public override func addToFlatList(_ bricks: inout [Brick]) { parent?.addToFlatList(&bricks) }
    public override var dragAndDropTargetList: [Brick] {
        return (parent as? CompositeBrick)?.secondaryNestedBricks ?? []
    }
    public override var positionInDragAndDropTargetList: Int { return -1 }
    public override var brickID: UUID { return parent?.brickID ?? brickId }
}
