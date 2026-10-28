import Foundation

open class DeviceUserDataAccessor {
    public let fileURL: URL
    private let lock = NSLock()
    public init(_ projectDirectory: URL, fileName: String) {
        self.fileURL = projectDirectory.appendingPathComponent(fileName)
    }
    public func readDictionary() -> [String: Any] {
        lock.lock(); defer { lock.unlock() }
        guard let data = try? Data(contentsOf: fileURL),
              let object = try? JSONSerialization.jsonObject(with: data),
              let dictionary = object as? [String: Any] else { return [:] }
        return dictionary
    }
    public func writeDictionary(_ dictionary: [String: Any]) {
        lock.lock(); defer { lock.unlock() }
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: [.sortedKeys]) else { return }
        try? FileManager.default.createDirectory(at: fileURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? data.write(to: fileURL, options: .atomic)
    }
}

public final class DeviceVariableAccessor: DeviceUserDataAccessor {
    public init(_ projectDirectory: URL) { super.init(projectDirectory, fileName: "device-variables.json") }
}

public final class DeviceListAccessor: DeviceUserDataAccessor {
    public init(_ projectDirectory: URL) { super.init(projectDirectory, fileName: "device-lists.json") }
}
