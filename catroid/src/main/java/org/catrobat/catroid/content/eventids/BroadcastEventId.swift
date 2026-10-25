import Foundation

public final class BroadcastEventId: EventId {
    public let message: String?

    public init(message: String?) {
        self.message = message
        super.init()
    }

    public override func isEqual(to other: EventId) -> Bool {
        guard let that = other as? BroadcastEventId else { return false }
        return message == that.message
    }

    public override var hashCode: Int {
        return message?.hashValue ?? 0
    }
}
