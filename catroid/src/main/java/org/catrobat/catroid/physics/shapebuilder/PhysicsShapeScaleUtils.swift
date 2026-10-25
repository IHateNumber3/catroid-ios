import Foundation

public enum PhysicsShapeScaleUtils {
    public static let coordinateScalingDecimalAccuracy: Float = 100.0

    public static func scaleShapes(_ shapes: [B2Shape]?, targetScale: Float) -> [B2Shape]? {
        return scaleShapes(shapes, targetScale: targetScale, originScale: 1.0)
    }

    public static func scaleShapes(_ shapes: [B2Shape]?, targetScale: Float, originScale: Float) -> [B2Shape]? {
        guard let shapes = shapes, !shapes.isEmpty, targetScale != 0.0, originScale != 0.0 else { return nil }
        if targetScale == originScale { return shapes }

        let scale = targetScale / originScale
        var scaled: [B2Shape] = []
        for shape in shapes where shape.type == .polygon {
            var xy: [NSNumber] = []
            for i in 0..<Int(shape.vertexCount) {
                let v = shape.vertex(at: i)
                xy.append(NSNumber(value: scaleCoordinate(Float(v.x), scale)))
                xy.append(NSNumber(value: scaleCoordinate(Float(v.y), scale)))
            }
            if let polygon = B2Shape.polygon(vertices: xy) {
                scaled.append(polygon)
            }
        }
        return scaled
    }

    /// Math.round(c * s * 100) / 100  (Java: half-up)
    public static func scaleCoordinate(_ coordinate: Float, _ scaleFactor: Float) -> Float {
        let v = coordinate * scaleFactor * coordinateScalingDecimalAccuracy
        return Float((v + 0.5).rounded(.down)) / coordinateScalingDecimalAccuracy
    }
}
