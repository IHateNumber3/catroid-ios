import Foundation

/// iOS-side compatibility wrapper replacing Android's resource-backed string provider.
public final class AndroidStringProvider: FormulaStringProvider {
    public init() {}
    public func getTrueOrFalse(_ value: Bool) -> String { value ? "true" : "false" }
    public func get(_ key: String) -> String { key }
    public func get(_ key: String, _ args: CVarArg...) -> String {
        String(format: key, arguments: args)
    }
}
