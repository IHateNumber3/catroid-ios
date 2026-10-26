import Foundation

public enum UserDefinedBrickDataType { case input, label }

open class UserDefinedBrickData {
    public internal(set) var type: UserDefinedBrickDataType

    public init(type: UserDefinedBrickDataType) { self.type = type }

    public var isInput: Bool { return type == .input }
    public var isLabel: Bool { return type == .label }
    public func getType() -> UserDefinedBrickDataType { return type }

    open var dataName: String { fatalError("dataName must be overridden") }
}
