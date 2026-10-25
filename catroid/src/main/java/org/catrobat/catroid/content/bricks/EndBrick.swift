import Foundation

/// Закрывающая «скобка» составного брика (в списках отображения).
public final class EndBrick: BrickBaseType {

    public required init() { super.init() }

    public init(parent endBrickParent: BrickBaseType) {
        super.init()
        setParent(endBrickParent)
    }

    public override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {}
    public override var isCommentedOut: Bool { return parent?.isCommentedOut ?? false }
    public override func consistsOfMultipleParts() -> Bool { return true }
    public override func getAllParts() -> [Brick] { return parent?.getAllParts() ?? [] }
    public override func addToFlatList(_ bricks: inout [Brick]) { parent?.addToFlatList(&bricks) }
    public override var dragAndDropTargetList: [Brick] { return parent?.parent?.dragAndDropTargetList ?? [] }
    public override var positionInDragAndDropTargetList: Int {
        guard let p = parent else { return -1 }
        return dragAndDropTargetList.firstIndex { $0 === p } ?? -1
    }
    public override var brickID: UUID { return parent?.brickID ?? brickId }
}
