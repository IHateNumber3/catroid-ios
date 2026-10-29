import Foundation
import UIKit

/// Помощники «как в Java»: toString/parseDouble/compare для Double.
public enum JavaCompat {
    public static func string(_ any: Any?) -> String {
        guard let any = any else { return "null" }
        switch any {
        case let d as Double: return double(d)
        case let f as Float: return double(Double(f))
        case let b as Bool: return b ? "true" : "false"
        case let s as String: return s
        default: return "\(any)"
        }
    }

    public static func double(_ d: Double) -> String {
        if d.isNaN { return "NaN" }
        if d.isInfinite { return d < 0 ? "-Infinity" : "Infinity" }
        var s = "\(d)"
        if let e = s.firstIndex(where: { $0 == "e" || $0 == "E" }) {
            var mant = String(s[s.startIndex..<e])
            var exp = String(s[s.index(after: e)...])
            if !mant.contains(".") { mant += ".0" }
            if exp.hasPrefix("+") { exp.removeFirst() }
            let neg = exp.hasPrefix("-")
            if neg { exp.removeFirst() }
            while exp.count > 1 && exp.hasPrefix("0") { exp.removeFirst() }
            s = mant + "E" + (neg ? "-" : "") + exp
        }
        return s
    }

    /// Double.parseDouble: допускает хвост f/F/d/D, пробелы по краям; NaN/Infinity строго
    public static func parseDouble(_ raw: String) -> Double? {
        var s = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.isEmpty { return nil }
        if let last = s.last, "fFdD".contains(last), s.count > 1 { s.removeLast() }
        switch s {
        case "NaN", "+NaN", "-NaN": return Double.nan
        case "Infinity", "+Infinity": return Double.infinity
        case "-Infinity": return -Double.infinity
        default: break
        }
        let allowed = Set("0123456789+-.eE")
        if s.contains(where: { !allowed.contains($0) }) { return nil }
        return Double(s)
    }

    /// Double.compareTo
    public static func compare(_ a: Double, _ b: Double) -> Int {
        if a < b { return -1 }
        if a > b { return 1 }
        let x = Int64(bitPattern: a.isNaN ? Double.nan.bitPattern : a.bitPattern)
        let y = Int64(bitPattern: b.isNaN ? Double.nan.bitPattern : b.bitPattern)
        return x == y ? 0 : (x < y ? -1 : 1)
    }

    /// (int) double: насыщение, NaN → 0
    public static func int(_ d: Double) -> Int {
        if d.isNaN { return 0 }
        if d >= Double(Int32.max) { return Int(Int32.max) }
        if d <= Double(Int32.min) { return Int(Int32.min) }
        return Int(d)
    }

    /// Math.round(double)
    public static func round(_ d: Double) -> Double {
        if d.isNaN { return 0 }
        return (d + 0.5).rounded(.down)
    }
}

public enum Conversions {
    public static let TRUE = 1.0
    public static let FALSE = 0.0

    private static let colorPattern = try! NSRegularExpression(pattern: "^#[0-9A-Fa-f]{6}$")

    private static func tryParseDouble(_ argument: String) -> Double? {
        if argument.contains(where: { "fFdD".contains($0) }) { return nil }
        return JavaCompat.parseDouble(argument)
    }

    public static func isValidHexColor(_ string: String?) -> Bool {
        guard let s = string else { return false }
        return colorPattern.firstMatch(in: s, range: NSRange(s.startIndex..., in: s)) != nil
    }

    /// Возвращает ARGB-Int как Android Color.parseColor
    public static func tryParseColor(_ string: String?, defaultValue: Int = Int(bitPattern: 0xFF000000)) -> Int {
        guard isValidHexColor(string), let s = string, let rgb = Int(s.dropFirst(), radix: 16) else { return defaultValue }
        return Int(bitPattern: 0xFF000000) | rgb
    }

    public static func convertArgumentToDouble(_ argument: Any?) -> Double? {
        guard let argument = argument else { return nil }
        if let s = argument as? String { return tryParseDouble(s) }
        return argument as? Double
    }

    public static func booleanToDouble(_ value: Bool) -> Double { return value ? TRUE : FALSE }
}
