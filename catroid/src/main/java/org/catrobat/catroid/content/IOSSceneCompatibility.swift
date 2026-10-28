import Foundation

/// Filename encoding used by scene folders. Keeps path separators and reserved characters out of names.
public enum FileMetaDataExtractor {
    public static func encodeSpecialCharsForFileSystem(_ name: String) -> String {
        let forbidden = CharacterSet(charactersIn: "/\\:?%*|\"<>\n\r")
        return name.components(separatedBy: forbidden).joined(separator: "_")
    }
}

/// Backpack storage location for scenes when no project is attached.
public final class BackpackListManager {
    public static let shared = BackpackListManager()
    public let backpackSceneDirectory: URL
    private init() {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        backpackSceneDirectory = base.appendingPathComponent("Backpack/Scenes", isDirectory: true)
    }
}

/// Compatibility model for clone-selection bricks used while editing a scene.
open class CloneBrick: BrickBaseType {
    public var selectedItem: Sprite?
    public required init() { super.init() }
    public func resetSpinner() { selectedItem = nil }
}

/// Message reference used by broadcast bricks.
open class BroadcastMessageBrick: BrickBaseType {
    public var broadcastMessage: String?
    public required init() { super.init() }
}
