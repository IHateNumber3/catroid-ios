import Foundation

/// XML: name, initialIndex, deviceValueKey (value/visible/dummy — transient)
public final class UserVariable: UserData, Hashable {

    public var name: String
    public var initialIndex: Int = -1
    public private(set) var deviceValueKey: UUID

    // transient
    public var value: Any = 0.0
    public var visible = true
    public var isVisible: Bool { get { visible } set { visible = newValue } }
    public func setVisible(_ visible: Bool) { self.visible = visible }
    public var isDummy = false

    public init() {
        self.name = ""
        self.deviceValueKey = UUID()
    }

    public init(name: String) {
        self.name = name
        self.deviceValueKey = UUID()
    }

    public init(name: String, value: Any) {
        self.name = name
        self.value = value
        self.deviceValueKey = UUID()
    }

    public init(_ variable: UserVariable) {
        self.name = variable.name
        self.value = variable.value
        self.deviceValueKey = UUID()
    }

    public var deviceKey: UUID { return deviceValueKey }
    public func setDeviceValueKey(_ key: UUID) { deviceValueKey = key }

    public func setValue(_ value: Any) { self.value = value }

    public func reset() { value = 0.0 }

    /// Java: variableToCheck.value.equals(value)
    public func hasSameValue(_ other: UserVariable) -> Bool {
        return (other.value as AnyObject).isEqual(value as AnyObject)
    }

    public static func == (l: UserVariable, r: UserVariable) -> Bool {
        return l === r || l.name == r.name
    }
    public func hash(into hasher: inout Hasher) { hasher.combine(name) }
}
