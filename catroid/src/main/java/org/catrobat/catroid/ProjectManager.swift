import Foundation
import os

public enum ProjectError: Error {
    case loading(String)
    case outdatedVersion(String)
    case compatibility(String)
}

/// Замена XstreamSerializer: XML-слой реализуется отдельно и регистрируется сюда.
public protocol ProjectSerializing {
    func loadProject(_ projectDir: URL) throws -> Project
    func saveProject(_ project: Project) throws
}

/// Замена SettingsFragment.*: проект сообщает, какие возможности ему нужны.
public protocol ProjectSettingsDelegate: AnyObject {
    func projectRequires(_ resources: ResourcesSet)
    func projectUsesLegoNXT(sensorMapping: Any?)
    func projectUsesLegoEV3(sensorMapping: Any?)
}

public enum BuildConfig {
    /// BuildConfig.FEATURE_LIST_AS_BASIC_DATATYPE
    public static var featureListAsBasicDatatype = false
}

public final class ProjectManager {

    public static let shared = ProjectManager()
    private static let logger = Logger(subsystem: "org.catrobat.catroid", category: "ProjectManager")
    private static let downloadedProjectsKey = "downloaded_projects"

    public static var serializer: ProjectSerializing?
    public weak var settingsDelegate: ProjectSettingsDelegate?

    private var project: Project?
    private var editedScene: Scene?
    private var playingScene: Scene?
    private var startSceneStorage: Scene?
    public var currentSprite: Sprite?
    private var downloadedProjects: [String: Bool] = [:]

    public init() {
        loadDownloadedProjects()
    }

    // MARK: - Current state

    public var currentProject: Project? { return project }

    public func setCurrentProject(_ project: Project?) {
        currentSprite = nil
        self.project = project
        if let p = project, !p.sceneList.isEmpty {
            editedScene = p.defaultScene
            playingScene = editedScene
        }
    }

    public var currentlyEditedScene: Scene! {
        get {
            if editedScene == nil, let p = project { editedScene = p.defaultScene }
            return editedScene
        }
        set {
            editedScene = newValue
            playingScene = newValue
        }
    }

    public var currentlyPlayingScene: Scene! {
        get {
            if playingScene == nil { playingScene = currentlyEditedScene }
            return playingScene
        }
        set { playingScene = newValue }
    }

    public var startScene: Scene! {
        get {
            if startSceneStorage == nil { startSceneStorage = currentlyEditedScene }
            return startSceneStorage
        }
        set { startSceneStorage = newValue }
    }

    public var isCurrentProjectLandscapeMode: Bool {
        guard let h = project?.xmlHeader else { return false }
        return h.virtualScreenWidth > h.virtualScreenHeight
    }

    @discardableResult
    public func setCurrentSceneAndSprite(sceneName: String, spriteName: String) -> Bool {
        guard let project = project else { return false }
        for scene in project.sceneList where scene.name == sceneName {
            currentlyEditedScene = scene
            for sprite in scene.spriteList where sprite.name == spriteName {
                currentSprite = sprite
                return true
            }
        }
        return false
    }

    public func resetProjectManager() {
        editedScene = nil
        playingScene = nil
        currentSprite = nil
    }

    // MARK: - Load

    public func loadProject(_ projectDir: URL) throws {
        let previous = project
        guard let serializer = Self.serializer else {
            throw ProjectError.loading(NSLocalizedString("error_load_project", value: "Error loading project", comment: ""))
        }
        let loaded: Project
        do {
            loaded = try serializer.loadProject(projectDir)
        } catch {
            Self.logger.error("\(String(describing: error))")
            restorePreviousProject(previous)
            throw ProjectError.loading(NSLocalizedString("error_load_project", value: "Error loading project", comment: ""))
        }
        project = loaded
        let version = loaded.catrobatLanguageVersion

        if version > Constants.currentCatrobatLanguageVersion {
            restorePreviousProject(previous)
            throw ProjectError.outdatedVersion(NSLocalizedString("error_outdated_version", value: "Outdated version", comment: ""))
        }
        if version < 0.9 && version != 0.8 {
            restorePreviousProject(previous)
            throw ProjectError.compatibility(NSLocalizedString("error_project_compatibility", value: "Incompatible project", comment: ""))
        }
        if version <= 0.91 { loaded.screenMode = .stretch }
        if version <= 0.992 { Self.updateCollisionFormulasTo993(loaded) }
        if version <= 0.993 { Self.updateSetPenColorFormulasTo994(loaded) }
        if version <= 0.994 { Self.updateArduinoValuesTo995(loaded) }
        if version <= 0.995 { Self.updateCollisionScriptsTo996(loaded) }
        if version <= 0.999 { Self.makeShallowCopiesDeepAgain(loaded) }
        if version <= 0.9993 { Self.updateScriptsToTreeStructure(loaded) }
        if version <= 0.99992 { Self.removePermissionsFile(loaded) }
        if version <= 0.9999995 { Self.updateBackgroundIndexTo9999995(loaded) }
        if version < 999.9 && !BuildConfig.featureListAsBasicDatatype { Self.flattenAllLists(loaded) }
        if version <= 1.03 { Self.updateDirectionProperty(loaded) }

        loaded.catrobatLanguageVersion = Constants.currentCatrobatLanguageVersion
        localizeBackgroundSprites(loaded, NSLocalizedString("background", value: "Background", comment: ""))
        Self.initializeScripts(loaded)

        if let delegate = settingsDelegate {
            for setting in loaded.settings {
                if let nxt = setting as? LegoNXTSetting { delegate.projectUsesLegoNXT(sensorMapping: nxt.sensorMapping); break }
            }
            for setting in loaded.settings {
                if let ev3 = setting as? LegoEV3Setting { delegate.projectUsesLegoEV3(sensorMapping: ev3.sensorMapping); break }
            }
            delegate.projectRequires(loaded.getRequiredResources())
        }
        playingScene = loaded.defaultScene
        currentSprite = nil
    }

    private func restorePreviousProject(_ previous: Project?) {
        project = previous
        if let p = previous { playingScene = p.defaultScene }
    }

    // MARK: - Create

    public func createNewEmptyProject(name: String, landscapeMode: Bool, castEnabled: Bool) throws {
        project = try DefaultProjectHandler.createAndSaveEmptyProject(name: name, landscapeMode: landscapeMode, castEnabled: castEnabled)
        currentSprite = nil
        editedScene = project?.defaultScene
        playingScene = editedScene
    }

    @discardableResult
    public func initializeDefaultProject() -> Bool {
        do {
            project = try DefaultProjectHandler.createAndSaveDefaultProject()
            currentSprite = nil
            editedScene = project?.defaultScene
            playingScene = editedScene
            return true
        } catch {
            Self.logger.error("Cannot initialize default project: \(String(describing: error))")
            return false
        }
    }

    public func createNewExampleProject(name: String, creatorType: DefaultProjectHandler.ProjectCreatorType, landscapeMode: Bool) throws {
        DefaultProjectHandler.shared.setDefaultProjectCreator(creatorType)
        project = try DefaultProjectHandler.createAndSaveDefaultProject(name: name, landscapeMode: landscapeMode)
        currentSprite = nil
        editedScene = project?.defaultScene
        playingScene = editedScene
    }

    // MARK: - Conflicts

    public func getGlobalVariableConflicts(_ p1: Project, _ p2: Project) -> [UserVariable] {
        var conflicts: [UserVariable] = []
        for a in p1.userVariables {
            for b in p2.userVariables where a.name == b.name && !a.hasSameValue(b) { conflicts.append(a) }
        }
        return conflicts
    }

    public func getGlobalListConflicts(_ p1: Project, _ p2: Project) -> [UserList] {
        var conflicts: [UserList] = []
        for a in p1.userLists {
            for b in p2.userLists where a.name == b.name && !Self.sameValues(a.value, b.value) { conflicts.append(a) }
        }
        return conflicts
    }

    private static func sameValues(_ a: [Any], _ b: [Any]) -> Bool {
        return a.count == b.count && zip(a, b).allSatisfy { ($0 as AnyObject).isEqual($1 as AnyObject) }
    }

    public static func checkForVariablesConflicts<T: Equatable>(global: [T], local: [T]) -> [T] {
        return local.filter { global.contains($0) }
    }

    // MARK: - Migrations

    private static func forEachScript(_ project: Project, _ body: (Sprite, Script) -> Void) {
        for scene in project.sceneList { for sprite in scene.spriteList { for script in sprite.scriptList { body(sprite, script) } } }
    }

    public static func makeShallowCopiesDeepAgain(_ project: Project) {
        for scene in project.sceneList {
            var fileNames: [String] = []
            for sprite in scene.spriteList {
                var looks: [LookData] = []
                for look in sprite.lookList {
                    var keep = true
                    if fileNames.contains(look.file.lastPathComponent) {
                        do { look.setFile(try StorageOperations.duplicateFile(look.file)) }
                        catch {
                            keep = false
                            logger.error("Cannot copy: \(look.file.path), removing LookData \(look.name) from \(project.name), \(scene.name), \(sprite.name).")
                        }
                    }
                    if keep { looks.append(look); fileNames.append(look.file.lastPathComponent) }
                    else { fileNames.append(look.file.lastPathComponent) }
                }
                sprite.setLookList(looks)
                var sounds: [SoundInfo] = []
                for sound in sprite.soundList {
                    var keep = true
                    if fileNames.contains(sound.file.lastPathComponent) {
                        do { sound.setFile(try StorageOperations.duplicateFile(sound.file)) }
                        catch {
                            keep = false
                            logger.error("Cannot copy: \(sound.file.path), removing SoundInfo \(sound.name) from \(project.name), \(scene.name), \(sprite.name).")
                        }
                    }
                    if keep { sounds.append(sound) }
                    fileNames.append(sound.file.lastPathComponent)
                }
                sprite.setSoundList(sounds)
            }
        }
    }

    private func localizeBackgroundSprites(_ project: Project, _ localizedName: String) {
        for scene in project.sceneList where !scene.spriteList.isEmpty {
            let background = scene.spriteList[0]
            background.renameSpriteAndUpdateCollisionFormulas(localizedName, scene: scene)
            background.look.zIndex = 0
        }
    }

    private static func initializeScripts(_ project: Project) {
        for scene in project.sceneList {
            for sprite in scene.spriteList {
                for script in sprite.scriptList {
                    script.setParents()
                    (script as? WhenBounceOffScript)?.updateSpriteToCollideWith(scene: scene)
                }
            }
        }
    }

    public static func flattenAllLists(_ project: Project) {
        forEachScript(project) { _, script in
            var flat: [Brick] = []
            script.addToFlatList(&flat)
            for brick in flat { (brick as? FormulaBrick)?.formulas.forEach { $0.flattenAllLists() } }
        }
    }

    public static func updateCollisionFormulasTo993(_ project: Project) {
        forEachScript(project) { _, script in
            var flat: [Brick] = []
            script.addToFlatList(&flat)
            for brick in flat { (brick as? FormulaBrick)?.formulas.forEach { $0.updateCollisionFormulasToVersion() } }
        }
    }

    public static func updateSetPenColorFormulasTo994(_ project: Project) {
        forEachScript(project) { _, script in
            for brick in script.brickList {
                if let b = brick as? SetPenColorBrick {
                    b.replaceFormulaBrickField(.phiroLightRed, .penColorRed)
                    b.replaceFormulaBrickField(.phiroLightGreen, .penColorGreen)
                    b.replaceFormulaBrickField(.phiroLightBlue, .penColorBlue)
                }
            }
        }
    }

    public static func updateArduinoValuesTo995(_ project: Project) {
        forEachScript(project) { _, script in
            for brick in script.brickList { (brick as? ArduinoSendPWMValueBrick)?.updateArduinoValues994to995() }
        }
    }

    public static func updateCollisionScriptsTo996(_ project: Project) {
        forEachScript(project) { sprite, script in
            guard let bounce = script as? WhenBounceOffScript, let full = bounce.spriteToBounceOffName else { return }
            let names = full.components(separatedBy: PhysicsCollisionListener.collisionMessageConnector)
            var target = names[0]
            if names[0] == sprite.name, names.count > 1 { target = names[1] }
            bounce.spriteToBounceOffName = target
        }
    }

    public static func updateBackgroundIndexTo9999995(_ project: Project) {
        forEachScript(project) { _, script in
            for brick in script.brickList {
                if brick is SetBackgroundByIndexBrick {
                    (brick as? FormulaBrick)?.replaceFormulaBrickField(.lookIndex, .backgroundIndex)
                } else if brick is SetBackgroundByIndexAndWaitBrick {
                    (brick as? FormulaBrick)?.replaceFormulaBrickField(.lookIndex, .backgroundWaitIndex)
                }
            }
        }
    }

    public static func updateScriptsToTreeStructure(_ project: Project) {
        forEachScript(project) { _, script in
            let builder = BrickTreeBuilder()
            builder.convertBricks(script.brickList)
            script.replaceBrickList(builder.toList())
        }
    }

    public static func removePermissionsFile(_ project: Project) {
        let file = project.directory.appendingPathComponent(Constants.permissionsFileName)
        try? FileManager.default.removeItem(at: file)
    }

    public static func updateDirectionProperty(_ project: Project) {
        forEachScript(project) { _, script in
            var flat: [Brick] = []
            script.addToFlatList(&flat)
            for brick in flat { (brick as? FormulaBrick)?.formulas.forEach { $0.updateDirectionPropertyToVersion() } }
        }
    }

    // MARK: - Downloaded projects flags

    public func addNewDownloadedProject(_ name: String) {
        if downloadedProjects[name] == nil || downloadedProjects[name] == true {
            downloadedProjects[name] = false
            saveDownloadedProjects()
        }
    }

    public func resetChangedFlag(_ project: Project) {
        if downloadedProjects[project.name] == true {
            downloadedProjects[project.name] = false
            saveDownloadedProjects()
        }
    }

    public func isChangedProject(_ project: Project) -> Bool {
        return downloadedProjects[project.name] ?? true
    }

    public func deleteDownloadedProjectInformation(_ name: String) { downloadedProjects.removeValue(forKey: name) }

    public func changedProject(_ name: String) {
        if downloadedProjects[name] == false {
            downloadedProjects[name] = true
            saveDownloadedProjects()
        }
    }

    public func moveChangedFlag(source: String, destination: String) {
        if downloadedProjects[source] != nil {
            downloadedProjects.removeValue(forKey: source)
            downloadedProjects[destination] = true
            saveDownloadedProjects()
        }
    }

    public func saveDownloadedProjects() {
        if let data = try? JSONEncoder().encode(downloadedProjects), let json = String(data: data, encoding: .utf8) {
            UserDefaults.standard.set(json, forKey: Self.downloadedProjectsKey)
        }
    }

    public func loadDownloadedProjects() {
        if let json = UserDefaults.standard.string(forKey: Self.downloadedProjectsKey),
           let data = json.data(using: .utf8),
           let map = try? JSONDecoder().decode([String: Bool].self, from: data) {
            downloadedProjects = map
        } else {
            downloadedProjects = [:]
        }
    }
}
