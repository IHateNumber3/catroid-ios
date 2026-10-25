import Foundation

/// Базовый класс брика (модельная часть). UI (view/checkbox/spinners) вынесен в слой BrickView.
/// Клонирование: required init() + copyState(from:) вместо Object.clone().
open class BrickBaseType: Brick {

    public var commentedOut = false
    public internal(set) var brickId = UUID()
    private weak var parentBrick: Brick?

    public required init() {}

    // MARK: Brick

    open var isCommentedOut: Bool { return commentedOut }
    open func setCommentedOut(_ commentedOut: Bool) { self.commentedOut = commentedOut }

    open func copyState(from other: BrickBaseType) {
        commentedOut = other.commentedOut
        brickId = UUID()
        parentBrick = nil
    }

    open func clone() -> Brick {
        let copy = type(of: self).init()
        copy.copyState(from: self)
        return copy
    }

    open func addRequiredResources(_ resourcesSet: ResourcesSet) {}

    open func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {}

    open func consistsOfMultipleParts() -> Bool { return false }
    open func getAllParts() -> [Brick] { return [self] }
    open func addToFlatList(_ bricks: inout [Brick]) { bricks.append(self) }

    open var script: Script? { return parent?.script }

    open var positionInScript: Int {
        if parent is ScriptBrick {
            return script?.brickList.firstIndex { $0 === self } ?? -1
        }
        return parent?.positionInScript ?? -1
    }

    public var parent: Brick? { return parentBrick }
    open func setParent(_ parent: Brick?) { parentBrick = parent }

    open var dragAndDropTargetList: [Brick] { return parent?.dragAndDropTargetList ?? [] }
    open var positionInDragAndDropTargetList: Int {
        return dragAndDropTargetList.firstIndex { $0 === self } ?? -1
    }

    open func removeChild(_ brick: Brick) -> Bool { return false }

    open func hasHelpPage() -> Bool { return true }

    open func getHelpUrl(category: String) -> String {
        return "https://wiki.catrobat.org/bin/view/Documentation/BrickDocumentation/" + String(describing: type(of: self))
    }

    open var brickID: UUID { return brickId }

    public func getPositionInformation() -> String {
        var position = -1
        var scriptName = "unknown"
        if parent != nil {
            position = positionInScript
            if let s = script { scriptName = String(describing: type(of: s)) }
        }
        position += 2
        return "Brick at position \(position)\nin \"\(scriptName)\""
    }

    // MARK: Nested bricks

    open func findBricksInNestedBricks(brickIds: [UUID]) -> [Brick]? {
        guard let composite = self as? CompositeBrick else { return nil }
        var found: [Brick] = []

        for brick in composite.nestedBricks {
            if brickIds.contains(brick.brickID) {
                found.append(brick)
            } else if brick is CompositeBrick, let tmp = brick.findBricksInNestedBricks(brickIds: brickIds) {
                return tmp
            }
            if brickIds.count == found.count { break }
        }
        if found.isEmpty && composite.hasSecondaryList {
            for brick in composite.secondaryNestedBricks {
                if brickIds.contains(brick.brickID) {
                    found.append(brick)
                } else if brick is CompositeBrick, let tmp = brick.findBricksInNestedBricks(brickIds: brickIds) {
                    return tmp
                }
                if brickIds.count == found.count { break }
            }
        }
        return found.isEmpty ? nil : found
    }

    /// Отличие от Java: после вставки «после найденного» сразу возвращаем true
    /// (в Java цикл продолжался по изменённому списку).
    open func addBrickInNestedBrick(parentId: UUID, subStackIndex: Int, bricksToAdd: [Brick]) -> Bool {
        guard let composite = self as? CompositeBrick else { return false }

        if brickID == parentId {
            if subStackIndex == 0 {
                composite.nestedBricks.insert(contentsOf: bricksToAdd, at: 0)
                return true
            } else if subStackIndex == 1 && composite.hasSecondaryList {
                composite.secondaryNestedBricks.insert(contentsOf: bricksToAdd, at: 0)
                return true
            }
        }

        if let i = composite.nestedBricks.firstIndex(where: { $0.brickID == parentId }), subStackIndex == -1 {
            composite.nestedBricks.insert(contentsOf: bricksToAdd, at: i + 1)
            return true
        }
        for brick in composite.nestedBricks where brick is CompositeBrick {
            if brick.addBrickInNestedBrick(parentId: parentId, subStackIndex: subStackIndex, bricksToAdd: bricksToAdd) {
                return true
            }
        }

        if !composite.hasSecondaryList { return false }

        if let i = composite.secondaryNestedBricks.firstIndex(where: { $0.brickID == parentId }), subStackIndex == -1 {
            composite.secondaryNestedBricks.insert(contentsOf: bricksToAdd, at: i + 1)
            return true
        }
        for brick in composite.secondaryNestedBricks where brick is CompositeBrick {
            if brick.addBrickInNestedBrick(parentId: parentId, subStackIndex: subStackIndex, bricksToAdd: bricksToAdd) {
                return true
            }
        }
        return false
    }
}
