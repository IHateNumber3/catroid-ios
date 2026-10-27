import Foundation

/// iOS-side compatibility wrapper replacing Android's resource-backed string provider.
public final class AndroidStringProvider {
    public init() {}
    public func get(_ key: String) -> String { key }
    public func get(_ key: String, _ args: CVarArg...) -> String {
        String(format: key, arguments: args)
    }
}
