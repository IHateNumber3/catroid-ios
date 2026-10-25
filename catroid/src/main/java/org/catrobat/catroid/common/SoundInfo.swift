import Foundation

/// XML: name и fileName — атрибуты
public final class SoundInfo: Nameable {

    public var name: String
    public private(set) var fileName: String?
    public private(set) var file: URL!
    public private(set) var isMidiFile = false

    public init() { self.name = "" }

    public init(name: String, file: URL, midiFile: Bool = false) {
        self.name = name
        self.file = file
        self.fileName = file.lastPathComponent
        self.isMidiFile = midiFile
    }

    public func xstreamFileName() -> String? {
        precondition(file == nil, "This should be used only to deserialize the Object. You should use file instead.")
        return fileName
    }

    public func setFile(_ file: URL) {
        self.file = file
        self.fileName = file.lastPathComponent
    }

    public func clone() -> SoundInfo {
        do {
            return SoundInfo(name: name, file: try StorageOperations.duplicateFile(file))
        } catch {
            fatalError("SoundInfo: Could not copy file: \(file.path)")
        }
    }
}
