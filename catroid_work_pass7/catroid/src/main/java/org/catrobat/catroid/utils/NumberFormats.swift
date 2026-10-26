import Foundation

public enum NumberFormats {
    private static let trimmable = try! NSRegularExpression(pattern: "^(-?[1-9]\\d*|0)\\.(0|\\d*[1-9]0)$")

    public static func trimTrailingCharacters(_ value: String?) -> String {
        guard let value = value else { return "" }
        if value.contains("."), trimmable.firstMatch(in: value, range: NSRange(value.startIndex..., in: value)) != nil {
            var s = value
            if s.hasSuffix("0") { s.removeLast() }
            if s.hasSuffix(".") { s.removeLast() }
            return s
        }
        return value
    }

    public static func toMetricUnitRepresentation(_ number: Int) -> String {
        var prefix = ""
        var absolute = number
        if number < 0 { prefix = "-"; absolute = abs(number) }
        if absolute >= 1_000_000 { return "\(prefix)\(absolute / 1_000_000)M" }
        if absolute >= 10_000 && absolute % 1_000 > 100 { return "\(prefix)\(absolute / 1_000).\(absolute % 1_000 / 100)k" }
        if absolute >= 1_000 { return "\(prefix)\(absolute / 1_000)k" }
        return String(number)
    }
}

public func trimTrailingCharacters(_ value: String?) -> String { return NumberFormats.trimTrailingCharacters(value) }
