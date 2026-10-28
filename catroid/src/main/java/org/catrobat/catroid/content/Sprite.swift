import Foundation
import UIKit
import os

/// XML-порядок ключей: name (атрибут), lookList, soundList, scriptList, nfcTagList,
/// userVariables, userLists, userDefinedBrickList.
/// Равенство — по имени (как в Java equals).
open class Sprite: Nameable, Hashable {

    private static let logger = Logger(subsystem: "org.catrobat.catroid", category: "Sprite")

    // MARK: - transient
    public var look: Look!
    public var penConfiguration = PenConfiguration()
    public var runningStitch = RunningStitch()
    public var plot = Plot()

    private var convertToSprite = false
    private var convertToGroupItemSprite = false

    /// Multimap<EventId, ScriptSequenceAction> (LinkedHashMultimap: порядок вставки, без дублей)
    public private(set) var idToEventThreadMap: [EventId: [ScriptSequenceAction]] = [:]
    private var conditionScriptTriggers: [ConditionScriptTrigger] = []
    private var usedTouchPointer: [Int] = []
    public var embroideryThreadColor: UIColor = .black
    public var actionFactory = ActionFactory()

    public var isClone = false
    public var myOriginal: Sprite?
    public var movedByStepsBrick = false

    private var gliding = false
    public var glidingVelocityX: Float = 0
    public var glidingVelocityY: Float = 0

    // MARK: - serialized
    public var name: String
    public internal(set) var scriptList: [Script] = []
    public internal(set) var lookList: [LookData] = []
    public internal(set) var soundList: [SoundInfo] = []
    public internal(set) var nfcTagList: [NfcTagData] = []
    public internal(set) var userVariables: [UserVariable] = []
    public internal(set) var userLists: [UserList] = []
    public internal(set) var userDefinedBrickList: [Brick] = []

    // MARK: - Init

    public init(name: String = "") {
        self.name = name
        self.look = Look(sprite: self)
    }

    /// Копирующий конструктор Sprite(Sprite, Scene)
    public convenience init(copying sprite: Sprite, destinationScene: Scene) throws {
        self.init(name: sprite.name)
        do {
            try copyLooksAndSounds(from: sprite, destinationScene: destinationScene, setUniqueName: false)
        } catch {
            Self.logger.error("\(String(describing: error))")
            throw error
        }
        scriptList.append(contentsOf: sprite.scriptList)
        nfcTagList.append(contentsOf: sprite.nfcTagList)
        userVariables.append(contentsOf: sprite.userVariables)
        userLists.append(contentsOf: sprite.userLists)
        userDefinedBrickList.append(contentsOf: sprite.userDefinedBrickList)
        sprite.look.copyTo(look)
        myOriginal = sprite
    }

    public func setLookList(_ list: [LookData]) { lookList = list }
    public func setSoundList(_ list: [SoundInfo]) { soundList = list }

    // MARK: - Hashable (== по имени)

    public static func == (lhs: Sprite, rhs: Sprite) -> Bool {
        return lhs === rhs || lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    public var description: String { return name }

    // MARK: - Bricks

    public var allBricks: [Brick] {
        var all: [Brick] = []
        for script in scriptList {
            all.append(script.scriptBrick)
            all.append(contentsOf: script.brickList)
        }
        return all
    }

    public func getUserDefinedBrickWithSameUserData(_ brick: UserDefinedBrick?) -> UserDefinedBrick? {
        guard let brick = brick else { return nil }
        for b in userDefinedBrickList {
            if let udb = b as? UserDefinedBrick, udb.isUserDefinedBrickDataEqual(brick) {
                return udb
            }
        }
        return nil
    }

    public func getUserDefinedBrick(byID id: UUID) -> UserDefinedBrick? {
        for b in userDefinedBrickList {
            if let udb = b as? UserDefinedBrick, udb.userDefinedBrickID == id {
                return udb
            }
        }
        return nil
    }

    public func containsUserDefinedBrickWithSameUserData(_ brick: UserDefinedBrick) -> Bool {
        return getUserDefinedBrickWithSameUserData(brick) != nil
    }

    public func addUserDefinedBrick(_ brick: UserDefinedBrick) {
        userDefinedBrickList.append(brick)
    }

    public func removeUserDefinedBrick(_ brick: UserDefinedBrick) {
        for script in scriptList {
            script.removeAllOccurrencesOfUserDefinedBrick(in: &script.brickList, userDefinedBrick: brick)
        }
        userDefinedBrickList.removeAll { $0 === brick }
    }

    public func addClonesOfUserDefinedBrickList(_ bricks: [UserDefinedBrick]) {
        for brick in bricks where !containsUserDefinedBrickWithSameUserData(brick) {
            if let copy = brick.clone() as? UserDefinedBrick {
                addUserDefinedBrick(copy)
            }
        }
    }

    public func doesUserBrickAlreadyExist(_ brick: UserDefinedBrick) -> Bool {
        return userDefinedBrickList.contains {
            ($0 as? UserDefinedBrick)?.isUserDefinedBrickDataEqual(brick) ?? false
        }
    }

    public func getPlaySoundBricks() -> [PlaySoundBrick] {
        return allBricks.compactMap { $0 as? PlaySoundBrick }
    }

    public func getUserDefinedScript(_ id: UUID) -> UserDefinedScript? {
        for script in scriptList {
            if let s = script as? UserDefinedScript, s.userDefinedBrickID == id { return s }
        }
        return nil
    }

    // MARK: - User data

    public func hasUserDataChanged<T: UserData>(newUserData: [T], oldUserData: [T]) -> Bool {
        if newUserData.count != oldUserData.count { return true }
        for data in newUserData where !checkUserData(data, oldUserData) {
            return true
        }
        return false
    }

    public func checkUserData<T: UserData>(_ newUserData: T, _ oldUserData: [T]) -> Bool {
        for data in oldUserData where data.name == newUserData.name {
            if let v = data as? UserVariable, let n = newUserData as? UserVariable {
                return v.hasSameValue(n)
            } else if let l = data as? UserList, let n = newUserData as? UserList {
                return l.hasSameListSize(n)
            }
            return true
        }
        return false
    }

    public func restoreUserDataValues<T: UserData>(current: [T], toRestore: [T]) {
        for data in current {
            for restore in toRestore {
                if let v = data as? UserVariable, let n = restore as? UserVariable {
                    if v.name == n.name { v.value = n.value }
                } else if let l = data as? UserList, let n = restore as? UserList {
                    if l.name == n.name { l.value = n.value }
                }
            }
        }
    }

    public func getUserVariablesCopy() -> [UserVariable] {
        return userVariables.map { UserVariable(name: $0.name, value: $0.value) }
    }

    public func getUserVariable(_ name: String) -> UserVariable? {
        return userVariables.first { $0.name == name }
    }

    @discardableResult
    public func addUserVariable(_ v: UserVariable) -> Bool {
        userVariables.append(v)
        return true
    }

    public func getUserListsCopy() -> [UserList] {
        return userLists.map { UserList(name: $0.name, value: $0.value) }
    }

    public func getUserList(_ name: String) -> UserList? {
        return userLists.first { $0.name == name }
    }

    @discardableResult
    public func addUserList(_ l: UserList) -> Bool {
        userLists.append(l)
        return true
    }

    public func resetUserData() {
        userVariables.forEach { $0.reset() }
        userLists.forEach { $0.reset() }
    }

    public func updateUserDataReferences(oldName: String, newName: String, item: UserData) {
        for script in scriptList {
            script.updateUserDataReferences(oldName: oldName, newName: newName, item: item)
        }
    }

    public func deselectElements(_ elements: [UserData]) {
        for script in scriptList {
            script.deselectElements(elements)
        }
    }

    // MARK: - Reset / lifecycle

    public func resetDrawingState() {
        penConfiguration = PenConfiguration()
        plot = Plot()
        runningStitch = RunningStitch()
    }

    public func resetSprite() {
        let resources = ResourcesSet()
        addRequiredResources(resources)
        if resources.contains(.physics) {
            let world = ProjectManager.shared.currentlyPlayingScene.getPhysicsWorld()
            look = PhysicsLook(sprite: self, physicsWorld: world)
        } else {
            look = Look(sprite: self)
        }
        lookList.forEach { $0.dispose() }
        if let first = lookList.first {
            look.setLookData(first)
        }
        resetDrawingState()
    }

    /// В Java поля обнулялись; здесь — очищаются/пересоздаются.
    public func invalidate() {
        idToEventThreadMap = [:]
        conditionScriptTriggers = []
        penConfiguration = PenConfiguration()
        plot = Plot()
        runningStitch = RunningStitch()
    }

    // MARK: - Condition triggers

    public func initConditionScriptTriggers() {
        conditionScriptTriggers.removeAll()
        for script in scriptList where script is WhenConditionScript {
            guard let brick = script.scriptBrick as? WhenConditionBrick,
                  let formula = brick.formulaWithBrickField(.ifCondition) else { continue }
            let trigger = ConditionScriptTrigger(formula: formula)
            if waitBeforeCheckingCollision(formula) {
                trigger.updateSceneFirstStart()
            }
            conditionScriptTriggers.append(trigger)
        }
    }

    public func resetConditionScriptTriggers() {
        conditionScriptTriggers.forEach { $0.resetStartTimeIfSceneRestarted() }
    }

    public func initIfConditionBrickTriggers() {
        for script in scriptList {
            guard let first = script.brickList.first else { continue }
            var formulas: [Formula] = []
            if let b = first as? IfThenLogicBeginBrick {
                formulas = b.formulas
            } else if let b = first as? IfLogicBeginBrick {
                formulas = b.formulas
            }
            for formula in formulas where waitBeforeCheckingCollision(formula) {
                formula.sceneFirstStart(true)
            }
        }
    }

    func waitBeforeCheckingCollision(_ formula: Formula) -> Bool {
        guard let root = formula.root else { return false }
        return root.elementType == .collisionFormula
    }

    func evaluateConditionScriptTriggers() {
        conditionScriptTriggers.forEach { $0.evaluateAndTriggerActions(sprite: self) }
    }

    // MARK: - Event threads

    public func initializeEventThreads(startType: EventType) {
        idToEventThreadMap.removeAll()
        for script in scriptList {
            createThreadAndAddToEventMap(script)
        }
        look.fire(EventWrapper(eventId: EventId(startType), waitForCompletion: false))
    }

    private func createThreadAndAddToEventMap(_ script: Script) {
        if script.commentedOut { return }
        guard let id = script.createEventId(for: self) else { return }
        let action = createSequenceAction(script)
        var list = idToEventThreadMap[id] ?? []
        if !list.contains(where: { $0 === action }) {
            list.append(action)
        }
        idToEventThreadMap[id] = list
    }

    public func createSequenceAction(_ script: Script) -> ScriptSequenceAction {
        let sequence = ActionFactory.createScriptSequenceAction(script) as! ScriptSequenceAction
        if !(type(of: script) == UserDefinedScript.self) {
            script.run(sprite: self, sequence: sequence)
        }
        return sequence
    }

    // MARK: - Convert (Sprite <-> GroupItemSprite)

    public func toBeConverted() -> Bool {
        return convertToSprite || convertToGroupItemSprite
    }

    public func setConvertToSprite(_ value: Bool) {
        convertToGroupItemSprite = false
        convertToSprite = value
    }

    public func setConvertToGroupItemSprite(_ value: Bool) {
        convertToSprite = false
        convertToGroupItemSprite = value
    }

    public func convert() -> Sprite {
        let converted: Sprite
        if convertToSprite {
            converted = Sprite(name: name)
        } else if convertToGroupItemSprite {
            converted = GroupItemSprite(name: name)
        } else {
            Self.logger.debug("Nothing to convert: if this is not what you wanted have a look at the convert flags.")
            return self
        }
        converted.look = Look(sprite: converted)
        converted.look.setLookData(look.lookData)
        converted.penConfiguration = penConfiguration
        converted.plot = plot
        converted.runningStitch = runningStitch
        converted.lookList = lookList
        converted.soundList = soundList
        converted.nfcTagList = nfcTagList
        converted.scriptList = scriptList
        converted.userVariables = userVariables
        converted.userLists = userLists
        converted.userDefinedBrickList = userDefinedBrickList
        return converted
    }

    // MARK: - Scripts

    public func addScript(_ script: Script?) {
        guard let script = script, !scriptList.contains(where: { $0 === script }) else { return }
        scriptList.append(script)
        script.releaseBrickKeepAlive()
    }

    public func prependScript(_ script: Script?) {
        guard let script = script, !scriptList.contains(where: { $0 === script }) else { return }
        scriptList.insert(script, at: 0)
        script.releaseBrickKeepAlive()
    }

    public func addScript(at index: Int, _ script: Script?) {
        guard let script = script, !scriptList.contains(where: { $0 === script }) else { return }
        scriptList.insert(script, at: index)
        script.releaseBrickKeepAlive()
    }

    public func getScript(at index: Int) -> Script? {
        if index < 0 || index >= scriptList.count {
            Self.logger.error("getScript() Index out of Scope! scriptList size: \(self.scriptList.count)")
            return nil
        }
        return scriptList[index]
    }

    public var numberOfScripts: Int { return scriptList.count }

    public var numberOfBricks: Int {
        var flat: [Brick] = []
        scriptList.forEach { $0.addToFlatList(&flat) }
        return flat.count - scriptList.count
    }

    public func getScriptIndex(_ script: Script) -> Int? {
        return scriptList.firstIndex { $0 === script }
    }

    public func removeAllScripts() { scriptList.removeAll() }

    @discardableResult
    public func removeScript(_ script: Script) -> Bool {
        if let i = scriptList.firstIndex(where: { $0 === script }) {
            scriptList.remove(at: i)
            return true
        }
        return false
    }

    public func findBrickInSprite(_ brickId: UUID) -> Brick? {
        for script in scriptList where script.scriptId == brickId {
            return script.scriptBrick
        }
        for script in scriptList {
            if let found = script.findBricksInScript(brickIds: [brickId]), let first = found.first {
                return first
            }
        }
        return nil
    }

    public func removeAllEmptyScriptBricks() -> [UUID] {
        var ids: [UUID] = []
        let toRemove = scriptList.filter { $0 is EmptyScript && $0.brickList.isEmpty }
        for script in toRemove {
            ids.append(script.scriptId)
        }
        scriptList.removeAll { s in toRemove.contains { $0 === s } }
        return ids
    }

    // MARK: - Resources

    public func addRequiredResources(_ resourcesSet: ResourcesSet) {
        for script in scriptList where !script.commentedOut {
            script.addRequiredResources(resourcesSet)
        }
        for lookData in lookList {
            lookData.addRequiredResources(resourcesSet)
        }
    }

    // MARK: - Rename / collision

    public func rename(_ newSpriteName: String) {
        renameSpriteAndUpdateCollisionFormulas(newSpriteName, scene: ProjectManager.shared.currentlyEditedScene)
    }

    public func renameSpriteAndUpdateCollisionFormulas(_ newSpriteName: String, scene: Scene) {
        if hasCollision(scene: scene) {
            renameSpriteInCollisionFormulas(newName: newSpriteName, scene: scene)
        }
        name = newSpriteName
    }

    public func hasCollision(scene: Scene) -> Bool {
        let resources = ResourcesSet()
        addRequiredResources(resources)
        if resources.contains(.collision) { return true }
        return scene.spriteList.contains { $0.hasToCollideWith(self) }
    }

    private func hasToCollideWith(_ other: Sprite) -> Bool {
        for script in scriptList {
            var flat: [Brick] = []
            script.addToFlatList(&flat)
            for brick in flat {
                if let fb = brick as? FormulaBrick {
                    for formula in fb.formulas where formula.containsSpriteInCollision(other.name) {
                        return true
                    }
                }
            }
        }
        return false
    }

    private func renameSpriteInCollisionFormulas(newName: String, scene: Scene) {
        let oldName = name
        for sprite in scene.spriteList {
            for script in sprite.scriptList {
                var flat: [Brick] = []
                script.addToFlatList(&flat)
                for brick in flat {
                    if let fb = brick as? FormulaBrick {
                        for formula in fb.formulas {
                            formula.updateCollisionFormulas(oldName: oldName, newName: newName)
                        }
                    }
                }
            }
        }
    }

    open func createCollisionPolygons() {
        lookList.forEach { $0.collisionInformation.calculate() }
    }

    // MARK: - Background

    public var isBackgroundSprite: Bool {
        return look.zIndex == Constants.zIndexBackground
    }

    public func isBackgroundSprite(localizedBackgroundName: String) -> Bool {
        return name == localizedBackgroundName
    }

    // MARK: - Touch pointers

    public func getUnusedPointer() -> Int {
        var result = 0
        while result < 20 && usedTouchPointer.contains(result) {
            result += 1
        }
        usedTouchPointer.append(result)
        return result
    }

    public func releaseUsedPointer(_ position: Int) {
        usedTouchPointer.removeAll { $0 == position }
    }

    public func releaseAllPointers() {
        if let stage = StageActivity.stageListener?.stage {
            for pointer in usedTouchPointer {
                TouchUtil.touchUp(pointer: pointer)
            }
        }
        usedTouchPointer.removeAll()
    }

    // MARK: - Gliding

    public var isGliding: Bool {
        get { return gliding }
        set { gliding = newValue }
    }

    // MARK: - Copy / merge

    private func copyLooksAndSounds(from sprite: Sprite, destinationScene: Scene, setUniqueName: Bool) throws {
        let imageDir = destinationScene.directory.appendingPathComponent(Constants.imageDirectoryName)
        let soundsDir = destinationScene.directory.appendingPathComponent(Constants.soundDirectoryName)

        for data in sprite.lookList {
            let lookFile = try StorageOperations.copyFileToDir(data.file, imageDir)
            let newData = data.clone()
            newData.setFile(lookFile)
            if setUniqueName {
                newData.name = UniqueNameProvider().getUniqueNameInNameables(newData.name, lookList)
            }
            lookList.append(newData)
        }
        for data in sprite.soundList {
            let soundFile = try StorageOperations.copyFileToDir(data.file, soundsDir)
            let newData = data.clone()
            newData.setFile(soundFile)
            if setUniqueName {
                newData.name = UniqueNameProvider().getUniqueNameInNameables(newData.name, soundList)
            }
            soundList.append(newData)
        }
    }

    public func mergeSprites(_ sprite: Sprite, destinationScene: Scene) throws {
        do {
            try copyLooksAndSounds(from: sprite, destinationScene: destinationScene, setUniqueName: true)
        } catch {
            Self.logger.error("\(String(describing: error))")
            throw error
        }
        scriptList.append(contentsOf: sprite.scriptList)
        nfcTagList.append(contentsOf: sprite.nfcTagList)
        for v in sprite.userVariables where !userVariables.contains(v) {
            userVariables.append(v)
        }
        for l in sprite.userLists where !userLists.contains(l) {
            userLists.append(l)
        }
        userDefinedBrickList.append(contentsOf: sprite.userDefinedBrickList)
    }
}
