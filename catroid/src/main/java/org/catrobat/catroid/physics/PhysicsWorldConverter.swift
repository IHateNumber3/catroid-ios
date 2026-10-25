import Foundation

public enum PhysicsWorldConverter {
    public static func convertBox2dToNormalAngle(_ a: Float) -> Float { return Float(Double(a) * 180 / .pi) }
    public static func convertNormalToBox2dAngle(_ a: Float) -> Float { return Float(Double(a) * .pi / 180) }
    public static func convertBox2dToNormalCoordinate(_ c: Float) -> Float { return c * PhysicsWorld.ratio }
    public static func convertNormalToBox2dCoordinate(_ c: Float) -> Float { return c / PhysicsWorld.ratio }
    public static func convertBox2dToNormalVector(_ v: Vector2) -> Vector2 {
        return Vector2(convertBox2dToNormalCoordinate(v.x), convertBox2dToNormalCoordinate(v.y))
    }
    public static func convertCatroidToBox2dVector(_ v: Vector2) -> Vector2 {
        return Vector2(convertNormalToBox2dCoordinate(v.x), convertNormalToBox2dCoordinate(v.y))
    }
}
