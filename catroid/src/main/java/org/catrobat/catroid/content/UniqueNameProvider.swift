import Foundation

/// Produces stable, human-readable unique names for sprite assets.
/// Kept in the content target because the original Android utility package is excluded on iOS.
public final class UniqueNameProvider {
    public init() {}

    public func getUniqueNameInNameables(_ name: String, _ scope: [Nameable]) -> String {
        let existing = Set(scope.map { $0.name })
        guard existing.contains(name) else { return name }
        let base = name.replacingOccurrences(
            of: "\\s*\\(\\d+\\)$",
            with: "",
            options: .regularExpression
        ).trimmingCharacters(in: .whitespacesAndNewlines)
        var index = 1
        while index < Int.max {
            let candidate = "\(base) (\(index))"
            if !existing.contains(candidate) { return candidate }
            index += 1
        }
        return base
    }
}
