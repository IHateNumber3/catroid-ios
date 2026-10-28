import Foundation

/// Generates a unique display name for looks and sounds in a sprite.
public final class UniqueNameProvider {
    public init() {}

    public func getUniqueNameInNameables(_ name: String, _ scope: [Nameable]) -> String {
        let existing = Set(scope.map { $0.name })
        if !existing.contains(name) { return name }
        let base = name.replacingOccurrences(of: "\\s*\\(\\d+\\)$", with: "", options: .regularExpression).trimmingCharacters(in: .whitespaces)
        var index = 1
        while index < Int.max {
            let candidate = "\(base) (\(index))"
            if !existing.contains(candidate) { return candidate }
            index += 1
        }
        return base
    }
}
