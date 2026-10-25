import Foundation
import UIKit
import os

/// XML <program>. Порядок ключей: header, settings, scenes, programVariableList,
/// programListOfLists, programMultiplayerVariableList.
public final class Project {

    public private(set) var xmlHeader = XmlHeader()                 // alias: header
    public private(set) var settings: [Setting] = []                 // alias: settings
    public private(set) var userVariables: [UserVariable] = []       // alias: programVariableList
    public private(set) var multiplayerVariables: [UserVariable] = []// alias: programMultiplayerVariableList
    public private(set) var userLists: [UserList] = []               // alias: programListOfLists
    public private(set) var sceneList: [Scene] = []                  // alias: scenes

    // transient
    private var directoryStorage: URL?
    public private(set) var broadcastMessageContainer = BroadcastMessageContainer()

    public init() {}

    public convenience init(name: String, landscapeMode: Bool = false, isCastProject: Bool = false) {
        self.init()
        xmlHeader.projectName = name
        xmlHeader.description = ""
        xmlHeader.notesAndCredits = ""
        xmlHeader.landscapeMode = landscapeMode

        if ScreenValues.currentScreenResolution == nil {
            ScreenValues.updateScreenWidthAndHeight()
        }
        if landscapeMode {
            ScreenValues.currentScreenResolution = ScreenValues.currentScreenResolution!.flipToLandscape()
        } else {
            ScreenValues.currentScreenResolution = ScreenValues.currentScreenResolution!.flipToPortrait()
        }
        xmlHeader.virtualScreenWidth = ScreenValues.currentScreenResolution!.width
        xmlHeader.virtualScreenHeight = ScreenValues.currentScreenResolution!.height

        if isCastProject {
            xmlHeader.virtualScreenHeight = ScreenValues.castScreenResolution.height
            xmlHeader.virtualScreenWidth = ScreenValues.castScreenResolution.width
            xmlHeader.landscapeMode = true
            xmlHeader.isCastProject = true
        }

        let scene = Scene(name: NSLocalizedString("default_scene_name", value: "Scene", comment: ""), project: self)
        let background = Sprite(name: NSLocalizedString("background", value: "Background", comment: ""))
        background.look.zIndex = Constants.zIndexBackground
        scene.addSprite(background)
        sceneList.append(scene)
        xmlHeader.scenesEnabled = true

        setDeviceData()
    }

    // MARK: - Directory

    public var directory: URL {
        get {
            if directoryStorage == nil {
                directoryStorage = FlavoredConstants.defaultRootDirectory.appendingPathComponent(
                    FileMetaDataExtractor.encodeSpecialCharsForFileSystem(name))
            }
            return directoryStorage!
        }
        set { directoryStorage = newValue }
    }

    // MARK: - Scenes

    public func getSceneNames() -> [String] { return sceneList.map { $0.name } }
    public func addScene(_ scene: Scene) { sceneList.append(scene) }
    public func removeScene(_ scene: Scene) { sceneList.removeAll { $0 === scene } }
    public func hasScene() -> Bool { return !sceneList.isEmpty }
    public var defaultScene: Scene { return sceneList[0] }
    public func getSceneByName(_ name: String) -> Scene? { return sceneList.first { $0.name == name } }

    // MARK: - User data (project-level)

    public func hasUserDataChanged<T: UserData>(newUserData: [T], oldUserData: [T]) -> Bool {
        if newUserData.count != oldUserData.count { return true }
        for data in newUserData where !checkEquality(data, oldUserData) { return true }
        return false
    }

    public func checkEquality<T: UserData>(_ newUserData: T, _ oldUserData: [T]) -> Bool {
        for data in oldUserData where data.name == newUserData.name {
            if let v = data as? UserVariable, let n = newUserData as? UserVariable { return v.hasSameValue(n) }
            if let l = data as? UserList, let n = newUserData as? UserList { return l.hasSameListSize(n) }
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
    public func getUserVariable(_ name: String) -> UserVariable? { return userVariables.first { $0.name == name } }
    @discardableResult public func addUserVariable(_ v: UserVariable) -> Bool { userVariables.append(v); return true }
    @discardableResult public func removeUserVariable(_ name: String) -> Bool {
        guard let i = userVariables.firstIndex(where: { $0.name == name }) else { return false }
        userVariables.remove(at: i); return true
    }

    public func getUserListsCopy() -> [UserList] {
        return userLists.map { UserList(name: $0.name, value: $0.value) }
    }
    public func getUserList(_ name: String) -> UserList? { return userLists.first { $0.name == name } }
    @discardableResult public func addUserList(_ l: UserList) -> Bool { userLists.append(l); return true }
    @discardableResult public func removeUserList(_ name: String) -> Bool {
        guard let i = userLists.firstIndex(where: { $0.name == name }) else { return false }
        userLists.remove(at: i); return true
    }

    public func getMultiplayerVariablesCopy() -> [UserVariable] {
        return multiplayerVariables.map { UserVariable(name: $0.name, value: $0.value) }
    }
    public func getMultiplayerVariable(_ name: String) -> UserVariable? { return multiplayerVariables.first { $0.name == name } }
    public func hasMultiplayerVariables() -> Bool { return !multiplayerVariables.isEmpty }
    @discardableResult public func addMultiplayerVariable(_ v: UserVariable) -> Bool { multiplayerVariables.append(v); return true }

    public func resetUserData() {
        userVariables.forEach { $0.reset() }
        userLists.forEach { $0.reset() }
        multiplayerVariables.forEach { $0.reset() }
    }

    public func isGlobalVariable(_ item: UserData) -> Bool {
        if let v = item as? UserVariable, userVariables.contains(v) || multiplayerVariables.contains(v) { return true }
        if let l = item as? UserList, userLists.contains(l) { return true }
        return false
    }

    public func updateUserDataReferences(oldName: String, newName: String, item: UserData) {
        sceneList.forEach { $0.updateUserDataReferences(oldName: oldName, newName: newName, item: item) }
    }

    public func deselectElements(_ elements: [UserData]) {
        sceneList.forEach { $0.deselectElements(elements) }
    }

    // MARK: - Sprites / events

    public func getSpriteListWithClones() -> [Sprite] {
        if let listener = StageActivity.stageListener {
            return listener.getSpritesFromStage()
        }
        return defaultScene.spriteList
    }

    public func fireToAllSprites(_ event: EventWrapper) {
        for sprite in getSpriteListWithClones() {
            sprite.look.fire(event)
        }
    }

    public func checkForInvisibleSprites() {
        sceneList.forEach { $0.checkForInvisibleSprites() }
    }

    public func getSpriteNames(_ list: [Sprite]) -> [String] { return list.map { $0.name } }

    public func checkIfSpriteNameEqualBackground() {
        let backgroundName = NSLocalizedString("background", value: "Background", comment: "")
        let sprites = getSpriteListWithClones()
        let names = getSpriteNames(sprites)
        let pattern = "^\\s*" + NSRegularExpression.escapedPattern(for: backgroundName) + "\\s*$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return }
        for i in 1..<max(1, sprites.count) {
            let n = sprites[i].name
            if regex.firstMatch(in: n, range: NSRange(n.startIndex..., in: n)) != nil {
                sprites[i].name = UniqueNameProvider().getUniqueName(backgroundName, names)
                return
            }
        }
    }

    // MARK: - Header passthrough

    public var name: String {
        get { return xmlHeader.projectName ?? "" }
        set { xmlHeader.projectName = newValue }
    }
    public var description: String {
        get { return xmlHeader.description ?? "" }
        set { xmlHeader.description = newValue }
    }
    public var notesAndCredits: String {
        get { return xmlHeader.notesAndCredits ?? "" }
        set { xmlHeader.notesAndCredits = newValue }
    }
    public var screenMode: ScreenModes {
        get { return xmlHeader.screenMode }
        set { xmlHeader.screenMode = newValue }
    }
    public var catrobatLanguageVersion: Double {
        get { return xmlHeader.catrobatLanguageVersion }
        set { xmlHeader.catrobatLanguageVersion = newValue }
    }
    public var tags: [String] {
        get { return xmlHeader.tags }
        set { xmlHeader.tags = newValue }
    }
    public var isCastProject: Bool { return xmlHeader.isCastProject }

    public func setXmlHeader(_ header: XmlHeader) { xmlHeader = header }

    public func getScreenRectangle() -> CGRect {
        let w = xmlHeader.virtualScreenWidth, h = xmlHeader.virtualScreenHeight
        // Java: целочисленное деление -w/2
        return CGRect(x: CGFloat(-w / 2), y: CGFloat(-h / 2), width: CGFloat(w), height: CGFloat(h))
    }

    // MARK: - Resources

    public func getRequiredResources() -> ResourcesSet {
        let resources = ResourcesSet()
        if isCastProject { resources.add(.castRequired) }
        if hasMultiplayerVariables() { resources.add(.bluetoothMultiplayer) }

        let physicsFactory = ActionPhysicsFactory()
        let factory = ActionFactory()
        for scene in sceneList {
            for sprite in scene.spriteList {
                sprite.addRequiredResources(resources)
                if resources.contains(.physics) {
                    sprite.actionFactory = physicsFactory
                    resources.remove(.physics)
                } else {
                    sprite.actionFactory = factory
                }
            }
        }
        return resources
    }

    // MARK: - Device data

    public func setDeviceData() {
        xmlHeader.platform = Constants.platformName
        xmlHeader.platformVersion = UIDevice.current.systemVersion
        xmlHeader.deviceName = UIDevice.current.model
        xmlHeader.catrobatLanguageVersion = Constants.currentCatrobatLanguageVersion
        xmlHeader.applicationBuildName = Constants.applicationBuildName
        xmlHeader.applicationBuildNumber = Constants.applicationBuildNumber
        let info = Bundle.main.infoDictionary
        xmlHeader.applicationVersion = info?["CFBundleShortVersionString"] as? String ?? "unknown"
        xmlHeader.applicationName = info?["CFBundleDisplayName"] as? String
            ?? info?["CFBundleName"] as? String ?? "unknown"
    }

    public func setListeningLanguageTag() {
        if xmlHeader.listeningLanguageTag.isEmpty, let first = Utils.speechRecognitionSupportedLanguages.first {
            xmlHeader.listeningLanguageTag = first
        }
    }
}
