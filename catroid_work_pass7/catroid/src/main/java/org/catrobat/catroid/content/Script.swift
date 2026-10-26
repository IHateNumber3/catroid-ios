import Foundation

/// Базовый класс всех скриптов (аналог Script.java).
/// Подклассы обязаны переопределить `scriptBrick` и `createEventId(for:)`.
open class Script {

    public internal(set) var brickList: [Brick] = []
    public internal(set) var commentedOut: Bool = false

    public var posX: Float = 0
    public var posY: Float = 0

    public internal(set) var scriptId: UUID = UUID()

    // transient в Java: не сериализуется
    var cachedScriptBrick: ScriptBrick?

    public required init() {}

    // MARK: - Abstract

    open func createEventId(for sprite: Sprite) -> EventId? {
        fatalError("createEventId(for:) must be overridden")
    }

    /// Ленивое создание ScriptBrick. Подклассы переопределяют.
    open var scriptBrick: ScriptBrick {
        fatalError("scriptBrick must be overridden")
    }

    // MARK: - Clone

    /// Копирует поля подкласса. Подклассы с доп. состоянием переопределяют и зовут super.
    open func copyState(from other: Script) {
        brickList = other.brickList.map { $0.clone() }
        commentedOut = other.commentedOut
        cachedScriptBrick = nil
        posX = other.posX
        posY = other.posY
        scriptId = UUID()
    }

    public final func clone() -> Script {
        let copy = type(of: self).init()
        copy.copyState(from: self)
        return copy
    }

    // MARK: - Accessors

    public func setCommentedOut(_ value: Bool) {
        commentedOut = value
        for brick in brickList {
            brick.setCommentedOut(value)
        }
    }

    public func setScriptBrick(_ brick: ScriptBrick?) {
        cachedScriptBrick = brick
    }

    /// Скрипт попал в Sprite — брик больше не обязан удерживать скрипт.
    public func releaseBrickKeepAlive() {
        (cachedScriptBrick as? ScriptBrickBaseType)?.scriptKeepAlive = nil
    }

    public func setParents() {
        let sb = scriptBrick
        sb.setParent(nil)
        for brick in brickList {
            brick.setParent(sb)
        }
    }

    // MARK: - Run

    open func run(sprite: Sprite, sequence: ScriptSequenceAction) {
        if commentedOut { return }
        for brick in brickList where !brick.isCommentedOut {
            brick.addActionToSequence(sprite: sprite, sequence: sequence)
        }
    }

    // MARK: - Brick list

    public func replaceBrickList(_ list: [Brick]) { brickList = list }

    @discardableResult
    public func addBrick(_ brick: Brick) -> Bool {
        brickList.append(brick)
        return true
    }

    public func addBrick(at position: Int, _ brick: Brick) {
        brickList.insert(brick, at: position)
    }

    public func addToFlatList(_ bricks: inout [Brick]) {
        bricks.append(scriptBrick)
        for brick in brickList {
            brick.addToFlatList(&bricks)
        }
    }

    public func getBrick(at index: Int) -> Brick {
        return brickList[index]
    }

    @discardableResult
    public func removeBrick(_ brick: Brick) -> Bool {
        if let index = brickList.firstIndex(where: { $0 === brick }) {
            brickList.remove(at: index)
            return true
        }
        for brickInList in brickList {
            if brickInList.removeChild(brick) {
                return true
            }
        }
        return false
    }

    public func removeAllOccurrencesOfUserDefinedBrick(in list: inout [Brick],
                                                       userDefinedBrick: UserDefinedBrick) {
        var index = 0
        while index < list.count {
            let current = list[index]
            if let composite = current as? CompositeBrick {
                removeAllOccurrencesOfUserDefinedBrick(in: &composite.nestedBricks,
                                                       userDefinedBrick: userDefinedBrick)
                if composite.hasSecondaryList {
                    removeAllOccurrencesOfUserDefinedBrick(in: &composite.secondaryNestedBricks,
                                                           userDefinedBrick: userDefinedBrick)
                }
            }
            if current is UserDefinedBrick && userDefinedBrick.isUserDefinedBrickDataEqual(current) {
                list.remove(at: index)
                continue
            }
            index += 1
        }
    }

    // MARK: - Resources

    open func addRequiredResources(_ resourcesSet: ResourcesSet) {
        for brick in brickList where !brick.isCommentedOut {
            brick.addRequiredResources(resourcesSet)
        }
    }

    // MARK: - User data

    public func updateUserDataReferences(oldName: String, newName: String, item: UserData) {
        var flatList: [Brick] = []
        addToFlatList(&flatList)

        let containedInListSelector = flatList.contains { $0 is ListSelectorBrick }

        for brick in flatList {
            if let formulaBrick = brick as? FormulaBrick {
                formulaBrick.updateUserDataReference(oldName: oldName,
                                                     newName: newName,
                                                     item: item,
                                                     renameAll: containedInListSelector)
            }
        }
    }

    public func deselectElements(_ elements: [UserData]) {
        var flatList: [Brick] = []
        addToFlatList(&flatList)
        for brick in flatList {
            if let selector = brick as? ListSelectorBrick {
                selector.deselectElements(elements)
            }
        }
    }

    // MARK: - Find / remove / insert

    public func findBricksInScript(brickIds: [UUID]) -> [Brick]? {
        var bricks: [Brick] = []

        for brick in brickList {
            if brickIds.contains(brick.brickID) {
                bricks.append(brick)
            } else if brick is CompositeBrick {
                if let nested = brick.findBricksInNestedBricks(brickIds: brickIds) {
                    return nested
                }
            }
            if bricks.count == brickIds.count {
                return bricks
            }
        }
        return bricks.isEmpty ? nil : bricks
    }

    @discardableResult
    public func removeBricksFromScript(brickIds: [UUID]) -> [Brick]? {
        let bricks = findBricksInScript(brickIds: brickIds)
        bricks?.forEach { removeBrick($0) }
        return bricks
    }

    public func insertBrickAfter(parentId: UUID, subStackIndex: Int, bricksToAdd: [Brick]) -> Bool {
        if subStackIndex == -1 {
            if scriptId == parentId || scriptBrick.brickID == parentId {
                brickList.insert(contentsOf: bricksToAdd, at: 0)
                return true
            }

            if let idx = brickList.firstIndex(where: { $0.brickID == parentId }) {
                // Java: index инкрементируется до break, т.е. вставка ПОСЛЕ найденного
                brickList.insert(contentsOf: bricksToAdd, at: idx + 1)
                return true
            }
        }

        for brick in brickList {
            if brick.addBrickInNestedBrick(parentId: parentId,
                                           subStackIndex: subStackIndex,
                                           bricksToAdd: bricksToAdd) {
                return true
            }
        }
        return false
    }
}
