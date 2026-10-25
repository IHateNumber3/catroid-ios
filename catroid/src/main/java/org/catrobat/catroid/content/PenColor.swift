import Foundation

public struct PenColor: Equatable {
    public var r: Float, g: Float, b: Float, a: Float
    public init(_ r: Float, _ g: Float, _ b: Float, _ a: Float) {
        self.r = r; self.g = g; self.b = b; self.a = a
    }
}
