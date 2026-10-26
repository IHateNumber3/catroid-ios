import Foundation
import CoreGraphics

public extension CGRect {
    /// com.badlogic.gdx.math.Rectangle.overlaps
    func gdxOverlaps(_ r: CGRect) -> Bool {
        return minX < r.minX + r.width && minX + width > r.minX && minY < r.minY + r.height && minY + height > r.minY
    }
    /// Rectangle.contains(x, y) — границы включительно
    func gdxContains(x px: Float, y py: Float) -> Bool {
        return Float(minX) <= px && Float(minX + width) >= px && Float(minY) <= py && Float(minY + height) >= py
    }
}

public enum Intersector {

    public static func intersectSegmentPolygon(_ p1: Vector2, _ p2: Vector2, _ polygon: Polygon) -> Bool {
        let v = polygon.getTransformedVertices()
        let x1 = p1.x, y1 = p1.y, x2 = p2.x, y2 = p2.y
        let n = v.count
        var x3 = v[n - 2], y3 = v[n - 1]
        var i = 0
        while i < n {
            let x4 = v[i], y4 = v[i + 1]
            let d = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)
            if d != 0 {
                let yd = y1 - y3, xd = x1 - x3
                let ua = ((x4 - x3) * yd - (y4 - y3) * xd) / d
                if ua >= 0 && ua <= 1 {
                    let ub = ((x2 - x1) * yd - (y2 - y1) * xd) / d
                    if ub >= 0 && ub <= 1 { return true }
                }
            }
            x3 = x4; y3 = y4
            i += 2
        }
        return false
    }

    public static func intersectSegmentCircle(_ start: Vector2, _ end: Vector2, _ center: Vector2, _ squareRadius: Float) -> Bool {
        var dx = end.x - start.x, dy = end.y - start.y
        let cx = center.x - start.x, cy = center.y - start.y
        let l = (dx * dx + dy * dy).squareRoot()
        if l > 0 { dx /= l; dy /= l }               // nor()
        let u = cx * dx + cy * dy
        let closest: Vector2
        if u <= 0 { closest = start }
        else if u >= l { closest = end }
        else { closest = Vector2(dx * u + start.x, dy * u + start.y) }
        let x = center.x - closest.x, y = center.y - closest.y
        return x * x + y * y <= squareRadius
    }
}
