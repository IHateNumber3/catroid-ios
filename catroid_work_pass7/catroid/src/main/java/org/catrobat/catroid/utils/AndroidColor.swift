import Foundation

/// Замена android.graphics.Color (ARGB-Int) для транслированного кода
public enum Color {
    public static let TRANSPARENT = 0
    public static let BLACK = Int(bitPattern: 0xFF000000)
    public static let WHITE = Int(bitPattern: 0xFFFFFFFF)

    public static func argb(_ a: Int, _ r: Int, _ g: Int, _ b: Int) -> Int {
        return ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF)
    }
    public static func rgb(_ r: Int, _ g: Int, _ b: Int) -> Int { return argb(0xFF, r, g, b) }
    public static func alpha(_ c: Int) -> Int { return (c >> 24) & 0xFF }
    public static func red(_ c: Int) -> Int { return (c >> 16) & 0xFF }
    public static func green(_ c: Int) -> Int { return (c >> 8) & 0xFF }
    public static func blue(_ c: Int) -> Int { return c & 0xFF }

    /// Color.argb8888ToColor(libGDX): заполняет PenColor
    public static func penColor(fromARGB c: Int) -> PenColor {
        return PenColor(Float(red(c)) / 255, Float(green(c)) / 255, Float(blue(c)) / 255, Float(alpha(c)) / 255)
    }
}
