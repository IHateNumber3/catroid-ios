import Foundation

public final class UserDefinedBrickEventId: EventId {
    public let userDefinedBrickID: UUID?
    public var userBrickParameters: [Any]?

    public init(userDefinedBrickID: UUID?, userBrickParameters: [Any]? = nil) {
        self.userDefinedBrickID = userDefinedBrickID
        self.userBrickParameters = userBrickParameters
        super.init()
    }

    // Как в Java: сравнивается только ID (параметры не участвуют)
    public override func isEqual(to other: EventId) -> Bool {
        guard let that = other as? UserDefinedBrickEventId else { return false }
        return userDefinedBrickID == that.userDefinedBrickID
    }

    public override var hashCode: Int {
        return userDefinedBrickID?.hashValue ?? 0
    }
}
