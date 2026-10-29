import Foundation

public final class UserList: UserData, Hashable {

    public var name: String
    public var initialIndex: Int = -1
    public private(set) var deviceListKey: UUID

    // transient
    public var value: [Any] = []

    public init() {
        self.name = ""
        self.deviceListKey = UUID()
    }

    public init(name: String) {
        self.name = name
        self.deviceListKey = UUID()
    }

    public init(name: String, value: [Any]) {
        self.name = name
        self.value = value
        self.deviceListKey = UUID()
    }

    public init(_ list: UserList) {
        self.name = list.name
        self.value = list.value
        self.deviceListKey = UUID()
    }

    public var deviceKey: UUID { return deviceListKey }
    public func setDeviceListKey(_ key: UUID) { deviceListKey = key }

    public func addListItem(_ item: Any) { value.append(item) }

    public func getIndexOf(_ item: Any) -> Int {
        return value.firstIndex { ($0 as AnyObject).isEqual(item as AnyObject) } ?? -1
    }

    public func reset() { value.removeAll() }

    public func hasSameListSize(_ other: UserList) -> Bool { return other.value.count == value.count }

    public static func == (l: UserList, r: UserList) -> Bool { return l === r || l.name == r.name }
    public func hash(into hasher: inout Hasher) { hasher.combine(name) }
}
