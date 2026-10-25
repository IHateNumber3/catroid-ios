import Foundation
import CoreGraphics

public enum CollisionDetection {

    public static func checkCollisionBetweenLooks(_ first: Look, _ second: Look) -> Bool {
        if !first.visible || !first.isLookVisible || !second.visible || !second.isLookVisible { return false }
        if !first.getHitbox().gdxOverlaps(second.getHitbox()) { return false }
        return checkCollisionBetweenPolygons(first.getCurrentCollisionPolygon(), second.getCurrentCollisionPolygon())
    }

    public static func checkCollisionBetweenPolygons(_ first: [Polygon], _ second: [Polygon]) -> Bool {
        let firstBoxes = first.map { $0.getBoundingRectangle() }
        let secondBoxes = second.map { $0.getBoundingRectangle() }
        for fi in first.indices {
            for si in second.indices {
                if firstBoxes[fi].gdxOverlaps(secondBoxes[si]) && intersectPolygons(first[fi], second[si]) { return true }
            }
        }
        return checkCollisionForPolygonsInPolygons(first, second)
    }

    public static func intersectPolygons(_ first: Polygon, _ second: Polygon) -> Bool {
        let v = first.getTransformedVertices()
        let n = v.count
        var i = 0
        while i < n {
            let v1 = Vector2(v[i], v[i + 1])
            let v2 = Vector2(v[(i + 2) % n], v[(i + 3) % n])
            if Intersector.intersectSegmentPolygon(v1, v2, second) { return true }
            i += 2
        }
        return false
    }

    public static func checkCollisionForPolygonsInPolygons(_ first: [Polygon], _ second: [Polygon]) -> Bool {
        for fp in first {
            var containedIn = 0
            let fv = fp.getTransformedVertices()
            for sp in second where sp.contains(fv[0], fv[1]) { containedIn += 1 }
            if containedIn % 2 != 0 { return true }
        }
        for sp in second {
            var containedIn = 0
            let sv = sp.getTransformedVertices()
            for fp in first where fp.contains(sv[0], sv[1]) { containedIn += 1 }
            if containedIn % 2 != 0 { return true }
        }
        return false
    }

    public static func getSecondSpriteNameFromCollisionFormulaString(_ formula: String?, _ project: Project) -> String? {
        guard let formula = formula else { return nil }
        let ns = formula as NSString
        var indexOfSprite = ns.length
        for scene in project.sceneList {
            for sprite in scene.spriteList {
                let range = ns.range(of: sprite.name, options: .backwards)
                let index = range.location == NSNotFound ? -1 : range.location
                let nameLength = (sprite.name as NSString).length
                if index > 0 && index + nameLength == ns.length && index < indexOfSprite {
                    indexOfSprite = index
                }
            }
        }
        if indexOfSprite >= ns.length { return nil }
        return ns.substring(from: indexOfSprite)
    }

    public static func collidesWithEdge(_ polygons: [Polygon], _ screen: CGRect) -> Bool {
        for polygon in polygons {
            let v = polygon.getTransformedVertices()
            var i = 0
            while i < v.count - 4 {
                let a = screen.gdxContains(x: v[i], y: v[i + 1])
                let b = screen.gdxContains(x: v[i + 2], y: v[i + 3])
                if a != b { return true }
                i += 2
            }
        }
        return false
    }

    /// Точки касания расширяются до кругов радиуса COLLISION_WITH_FINGER_TOUCH_RADIUS
    public static func collidesWithFinger(_ polygons: [Polygon], _ touchingPoints: [CGPoint]) -> Double {
        let r = Constants.collisionWithFingerTouchRadius
        for point in touchingPoints {
            let px = Float(point.x), py = Float(point.y)
            let center = Vector2(px, py)
            var containedIn = 0
            for polygon in polygons {
                var box = polygon.getBoundingRectangle()
                box = CGRect(x: box.minX - CGFloat(r), y: box.minY - CGFloat(r),
                             width: box.width + CGFloat(r * 2), height: box.height + CGFloat(r * 2))
                if box.gdxContains(x: px, y: py) {
                    let v = polygon.getTransformedVertices()
                    var f = 0
                    while f < polygon.vertices.count - 3 {
                        let start = Vector2(v[f], v[f + 1]), end = Vector2(v[f + 2], v[f + 3])
                        f += 4   // как в Java: f++ ×4 за итерацию (сегменты через один)
                        if Intersector.intersectSegmentCircle(start, end, center, r * r) { return 1.0 }
                    }
                    let start = Vector2(v[v.count - 2], v[v.count - 1]), end = Vector2(v[0], v[1])
                    if Intersector.intersectSegmentCircle(start, end, center, r * r) { return 1.0 }
                    if polygon.contains(px, py) { containedIn += 1 }
                }
            }
            if containedIn % 2 != 0 { return 1.0 }
        }
        return 0.0
    }
}
