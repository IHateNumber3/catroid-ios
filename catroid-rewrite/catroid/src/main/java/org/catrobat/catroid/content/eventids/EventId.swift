import Foundation

public enum EventType: Int {
    case other = 0, tap, tapBackground, start, startAsClone, anyNfc
}

/// В Java equals/hashCode переопределяются в подклассах; в Swift это isEqual(to:)/hashCode.
open class EventId: Hashable {

    public static let other = EventType.other
    public static let tap = EventType.tap
    public static let tapBackground = EventType.tapBackground
    public static let start = EventType.start
    public static let startAsClone = EventType.startAsClone
    public static let anyNfc = EventType.anyNfc

    private let type: EventType

    public init(_ type: EventType) {
        self.type = type
    }

    /// protected EventId()
    public init() {
        self.type = .other
    }

    open func isEqual(to other: EventId) -> Bool {
        return type == other.type
    }

    open var hashCode: Int {
        return type.rawValue
    }

    public static func == (lhs: EventId, rhs: EventId) -> Bool {
        return lhs === rhs || lhs.isEqual(to: rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hashCode)
    }
}
