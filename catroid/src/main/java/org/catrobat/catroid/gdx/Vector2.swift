import Foundation

public struct Vector2: Equatable {
    public var x: Float
    public var y: Float
    public init(_ x: Float = 0, _ y: Float = 0) { self.x = x; self.y = y }
    public func len() -> Float { return (x * x + y * y).squareRoot() }
    /// libGDX rotate(degrees)
    public func rotated(degrees: Float) -> Vector2 {
        let r = Double(degrees) * .pi / 180
        let c = Float(cos(r)), s = Float(sin(r))
        return Vector2(x * c - y * s, x * s + y * c)
    }
    public static func + (a: Vector2, b: Vector2) -> Vector2 { return Vector2(a.x + b.x, a.y + b.y) }
}
