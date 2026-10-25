import Foundation

/// XML <header>. XStream-алиасы: virtualScreenWidth→screenWidth, virtualScreenHeight→screenHeight,
/// remixGrandparentsUrlString→remixOf, remixParentsUrlString→url. programName пишется как есть.
public final class XmlHeader {

    public var programName: String?
    public var description: String?
    public var notesAndCredits: String?

    public var virtualScreenWidth: Int = 0      // alias: screenWidth
    public var virtualScreenHeight: Int = 0     // alias: screenHeight
    public var screenMode: ScreenModes = .stretch
    public var catrobatLanguageVersion: Double = 0
    public var landscapeMode: Bool = false
    public var isCastProject: Bool = false
    public var scenesEnabled: Bool = true
    public var listeningLanguageTag: String = ""
    private var projectUuidStorage: String?
    public var applicationBuildName: String = ""
    public var applicationBuildNumber: Int = 0
    public var applicationName: String = ""
    public var applicationVersion: String = ""
    public var applicationBuildType: String = ""
    public var deviceName: String = ""
    public var platform: String = ""
    public var platformVersion: String = ""
    private var tagsStorage: String = ""
    public var remixGrandparentsUrlString: String = ""   // alias: remixOf
    public var remixParentsUrlString: String = ""        // alias: url
    public var userHandle: String = ""
    public var dateTimeUpload: String = ""
    public var mediaLicense: String = ""
    public var programLicense: String = ""

    public init() {}

    public var projectName: String? {
        get { return programName }
        set { programName = newValue }
    }

    public var tags: [String] {
        get { return tagsStorage.components(separatedBy: ",") }
        set { tagsStorage = newValue.joined(separator: ",") }
    }

    /// Стабильный UUID проекта; генерируется при первом обращении (для старых проектов).
    public var projectUuid: String {
        get {
            if projectUuidStorage == nil || projectUuidStorage!.isEmpty {
                projectUuidStorage = UUID().uuidString.lowercased()
            }
            return projectUuidStorage!
        }
        set { projectUuidStorage = newValue }
    }
}
