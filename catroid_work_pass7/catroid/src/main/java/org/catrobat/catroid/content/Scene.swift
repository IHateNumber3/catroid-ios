import Foundation

/// XML: <scene><name/><objectList/></scene>  (порядок ключей: name, objectList)
public final class Scene: Nameable, Hashable {

    public var name: String
    /// XStreamAlias("objectList")
    public private(set) var spriteList: [Sprite] = []

    // transient
    private var physicsWorld: PhysicsWorld?
    public weak var project: Project?
    public var firstStart: Bool = true

    private let lock = NSRecursiveLock()

    public init() {
        self.name = ""
    }

    public init(name: String, project: Project) {
        self.name = name
        self.project = project
    }

    public func setName(_ name: String) {
        lock.lock(); defer { lock.unlock() }
        self.name = name
    }

    public func setProject(_ project: Project?) {
        lock.lock(); defer { lock.unlock() }
        self.project = project
    }

    public func getSprite(_ spriteName: String) -> Sprite? {
        return spriteList.first { $0.name == spriteName }
    }

    public var backgroundSprite: Sprite? {
        return spriteList.first
    }

    public func addSprite(_ sprite: Sprite) {
        lock.lock(); defer { lock.unlock() }
        if spriteList.contains(sprite) { return }
        spriteList.append(sprite)
    }

    @discardableResult
    public func removeSprite(_ sprite: Sprite) -> Bool {
        lock.lock(); defer { lock.unlock() }
        if let i = spriteList.firstIndex(of: sprite) {
            spriteList.remove(at: i)
            return true
        }
        return false
    }

    /// Для XML-декодера и drag&drop (в Java возвращался изменяемый список)
    public func setSpriteList(_ list: [Sprite]) {
        spriteList = list
    }

    public func insertSprite(_ sprite: Sprite, at index: Int) {
        spriteList.insert(sprite, at: index)
    }

    // MARK: - Physics

    public func getPhysicsWorld() -> PhysicsWorld {
        if physicsWorld == nil { _ = resetPhysicsWorld() }
        return physicsWorld!
    }

    @discardableResult
    public func resetPhysicsWorld() -> PhysicsWorld {
        lock.lock(); defer { lock.unlock() }
        let header = project!.xmlHeader
        let world = PhysicsWorld(width: header.virtualScreenWidth, height: header.virtualScreenHeight)
        physicsWorld = world
        return world
    }

    public func setPhysicsWorld(_ world: PhysicsWorld?) {
        lock.lock(); defer { lock.unlock() }
        physicsWorld = world
    }

    // MARK: - Files

    public var directory: URL {
        let encoded = FileMetaDataExtractor.encodeSpecialCharsForFileSystem(name)
        if let project = project {
            return project.directory.appendingPathComponent(encoded)
        }
        return BackpackListManager.shared.backpackSceneDirectory.appendingPathComponent(encoded)
    }

    // MARK: - Clones

    public func removeClonedSprites() {
        spriteList.removeAll { $0.isClone }
    }

    public func removeSpriteFromCloneBricks(_ spriteToDelete: Sprite) {
        for current in spriteList where current != spriteToDelete {
            for script in current.scriptList {
                var flat: [Brick] = []
                script.addToFlatList(&flat)
                for brick in flat {
                    if let cloneBrick = brick as? CloneBrick,
                       let selected = cloneBrick.selectedItem,
                       selected == spriteToDelete {
                        cloneBrick.resetSpinner()
                    }
                }
            }
        }
    }

    // MARK: - Broadcast messages

    public func getBroadcastMessagesInUse() -> [String] {
        var messages: [String] = []   // порядок вставки сохраняется (LinkedHashSet)
        func add(_ m: String?) {
            guard let m = m, !messages.contains(m) else { return }
            messages.append(m)
        }
        for sprite in spriteList {
            for script in sprite.scriptList {
                if let b = script as? BroadcastScript { add(b.broadcastMessage) }
                var flat: [Brick] = []
                script.addToFlatList(&flat)
                for brick in flat {
                    if let b = brick as? BroadcastMessageBrick { add(b.broadcastMessage) }
                }
            }
        }
        return messages
    }

    public func editBroadcastMessagesInUse(oldMessage: String, newMessage: String) {
        for sprite in spriteList {
            for script in sprite.scriptList {
                if let b = script as? BroadcastScript, b.broadcastMessage == oldMessage {
                    b.broadcastMessage = newMessage
                }
                var flat: [Brick] = []
                script.addToFlatList(&flat)
                for brick in flat {
                    if let b = brick as? BroadcastMessageBrick, b.broadcastMessage == oldMessage {
                        b.broadcastMessage = newMessage
                    }
                }
            }
        }
    }

    // MARK: - User data

    public func updateUserDataReferences(oldName: String, newName: String, item: UserData) {
        let manager = ProjectManager.shared
        if manager.currentProject!.isGlobalVariable(item) {
            for sprite in spriteList {
                sprite.updateUserDataReferences(oldName: oldName, newName: newName, item: item)
            }
        } else {
            manager.currentSprite!.updateUserDataReferences(oldName: oldName, newName: newName, item: item)
        }
    }

    public func deselectElements(_ elements: [UserData]) {
        for sprite in spriteList {
            sprite.deselectElements(elements)
        }
    }

    // MARK: - Groups

    public func checkForInvisibleSprites() {
        for sprite in spriteList where sprite is GroupItemSprite {
            guard let index = spriteList.firstIndex(of: sprite) else { continue }
            if isInvisibleSprite(at: index) {
                sprite.setConvertToSprite(true)
                spriteList[index] = sprite.convert()
            }
        }
    }

    private func isInvisibleSprite(at index: Int) -> Bool {
        var i = index - 1
        while i > 0 {
            let current = spriteList[i]
            if !(current is GroupItemSprite) {
                return !(current is GroupSprite)
            }
            i -= 1
        }
        return true
    }

    // MARK: - Hashable

    public static func == (l: Scene, r: Scene) -> Bool { return l === r }
    public func hash(into h: inout Hasher) { h.combine(ObjectIdentifier(self)) }
}
