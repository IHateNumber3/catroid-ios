import Foundation
import CoreGraphics

/// Порт com.badlogic.gdx.math.Polygon (достаточно для коллизий Catroid).
public final class Polygon {
    private var localVertices: [Float]
    private var worldVertices: [Float] = []
    private var x: Float = 0, y: Float = 0
    private var originX: Float = 0, originY: Float = 0
    private var rotation: Float = 0
    private var scaleX: Float = 1, scaleY: Float = 1
    private var dirty = true

    public init(_ vertices: [Float]) {
        precondition(vertices.count >= 6, "polygons must contain at least 3 points.")
        self.localVertices = vertices
    }

    public var vertices: [Float] { return localVertices }

    public func getTransformedVertices() -> [Float] {
        if !dirty { return worldVertices }
        dirty = false
        worldVertices = [Float](repeating: 0, count: localVertices.count)
        let cos = Float(Foundation.cos(Double(rotation) * .pi / 180))
        let sin = Float(Foundation.sin(Double(rotation) * .pi / 180))
        var i = 0
        while i < localVertices.count {
            var vx = localVertices[i] - originX
            var vy = localVertices[i + 1] - originY
            if scaleX != 1 || scaleY != 1 { vx *= scaleX; vy *= scaleY }
            if rotation != 0 {
                let nx = cos * vx - sin * vy
                let ny = sin * vx + cos * vy
                vx = nx; vy = ny
            }
            worldVertices[i] = vx + x + originX
            worldVertices[i + 1] = vy + y + originY
            i += 2
        }
        return worldVertices
    }

    public func translate(_ dx: Float, _ dy: Float) { x += dx; y += dy; dirty = true }
    public func setPosition(_ px: Float, _ py: Float) { x = px; y = py; dirty = true }
    public func setOrigin(_ ox: Float, _ oy: Float) { originX = ox; originY = oy; dirty = true }
    public func setRotation(_ r: Float) { rotation = r; dirty = true }
    public func setScale(_ sx: Float, _ sy: Float) { scaleX = sx; scaleY = sy; dirty = true }

    public func getBoundingRectangle() -> CGRect {
        let v = getTransformedVertices()
        var minX = v[0], minY = v[1], maxX = v[0], maxY = v[1]
        var i = 2
        while i < v.count {
            minX = min(minX, v[i]); maxX = max(maxX, v[i])
            minY = min(minY, v[i + 1]); maxY = max(maxY, v[i + 1])
            i += 2
        }
        return CGRect(x: CGFloat(minX), y: CGFloat(minY), width: CGFloat(maxX - minX), height: CGFloat(maxY - minY))
    }

    /// Алгоритм из libGDX (even-odd).
    public func contains(_ px: Float, _ py: Float) -> Bool {
        let v = getTransformedVertices()
        let n = v.count
        var intersects = 0
        var i = 0
        while i < n {
            let x1 = v[i], y1 = v[i + 1]
            let x2 = v[(i + 2) % n], y2 = v[(i + 3) % n]
            if ((y1 <= py && py < y2) || (y2 <= py && py < y1)) &&
                px < ((x2 - x1) / (y2 - y1) * (py - y1) + x1) {
                intersects += 1
            }
            i += 2
        }
        return intersects & 1 == 1
    }
}
