import Foundation

/// Minimal Foundation-backed counterpart used by the Swift iOS port.
enum StorageOperations {
    static func duplicateFile(_ source: URL) throws -> URL {
        let manager = FileManager.default
        guard manager.fileExists(atPath: source.path) else {
            throw CocoaError(.fileNoSuchFile, userInfo: [NSFilePathErrorKey: source.path])
        }
        let directory = source.deletingLastPathComponent()
        let ext = source.pathExtension
        let base = source.deletingPathExtension().lastPathComponent
        var destination = directory.appendingPathComponent("\(base)_copy\(ext.isEmpty ? "" : ".\(ext)")")
        var index = 2
        while manager.fileExists(atPath: destination.path) {
            destination = directory.appendingPathComponent("\(base)_copy\(index)\(ext.isEmpty ? "" : ".\(ext)")")
            index += 1
        }
        try manager.copyItem(at: source, to: destination)
        return destination
    }

    static func copyFileToDir(_ source: URL, _ destinationDirectory: URL) throws -> URL {
        let manager = FileManager.default
        guard manager.fileExists(atPath: source.path) else {
            throw CocoaError(.fileNoSuchFile, userInfo: [NSFilePathErrorKey: source.path])
        }
        guard manager.fileExists(atPath: destinationDirectory.path) else {
            throw CocoaError(.fileNoSuchFile, userInfo: [NSFilePathErrorKey: destinationDirectory.path])
        }
        let destination = destinationDirectory.appendingPathComponent(source.lastPathComponent)
        if manager.fileExists(atPath: destination.path) {
            return try duplicateFile(source)
        }
        try manager.copyItem(at: source, to: destination)
        return destination
    }
}
