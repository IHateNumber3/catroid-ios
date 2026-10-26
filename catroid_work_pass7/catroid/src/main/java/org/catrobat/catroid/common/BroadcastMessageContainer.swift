import Foundation

public final class BroadcastMessageContainer {
    private var broadcastMessages: [String] = []

    public init() {}

    public func update() {
        let used = ProjectManager.shared.currentlyEditedScene.getBroadcastMessagesInUse()
        broadcastMessages = used
    }

    @discardableResult
    public func addBroadcastMessage(_ message: String?) -> Bool {
        guard let m = message, !m.isEmpty, !broadcastMessages.contains(m) else { return false }
        broadcastMessages.append(m)
        return true
    }

    @discardableResult
    public func removeBroadcastMessage(_ message: String?) -> Bool {
        guard let m = message, !m.isEmpty, let i = broadcastMessages.firstIndex(of: m) else { return false }
        broadcastMessages.remove(at: i)
        return true
    }

    public func getBroadcastMessages() -> [String] {
        if broadcastMessages.isEmpty { update() }
        return broadcastMessages
    }
}
