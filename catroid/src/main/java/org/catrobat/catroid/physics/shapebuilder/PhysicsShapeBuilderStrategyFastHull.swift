import Foundation

public final class PhysicsShapeBuilderStrategyFastHull: PhysicsShapeBuilderStrategy {

    private static let minimumPixelAlphaValue: UInt32 = 1

    public init() {}

    public func build(pixmap: Pixmap?, scale: Float) -> [B2Shape]? {
        guard let pixmap = pixmap else { return nil }
        let width = pixmap.width
        let height = pixmap.height
        let adjust: Float = 1.0
        let minAlpha = Self.minimumPixelAlphaValue

        var hull: [Vector2] = []
        var point = Vector2(Float(width), Float(height))

        // 1) верхний левый контур
        for y in 0..<height {
            var x = 0
            while Float(x) < point.x {
                if (pixmap.getPixel(x, y) & 0xff) >= minAlpha {
                    point = Vector2(Float(x), Float(y))
                    addPoint(&hull, point)
                    break
                }
                x += 1
            }
        }
        if hull.isEmpty { return nil }

        // 2) нижний левый
        var x = Int(point.x)
        while x < width {
            var y = height - 1
            while Float(y) > point.y {
                if (pixmap.getPixel(x, y) & 0xff) >= minAlpha {
                    point = Vector2(Float(x), Float(y))
                    addPoint(&hull, Vector2(Float(x), Float(y) + adjust))
                    break
                }
                y -= 1
            }
            x += 1
        }

        // 3) нижний правый
        let firstPoint = hull[0]
        var y = Int(point.y)
        while Float(y) >= firstPoint.y {
            var xx = width - 1
            while Float(xx) > point.x {
                if (pixmap.getPixel(xx, y) & 0xff) >= minAlpha {
                    point = Vector2(Float(xx), Float(y))
                    addPoint(&hull, Vector2(Float(xx) + adjust, Float(y) + adjust))
                    break
                }
                xx -= 1
            }
            y -= 1
        }

        // 4) верхний правый
        var px = Int(point.x)
        while Float(px) > firstPoint.x {
            var yy = Int(firstPoint.y)
            while Float(yy) < point.y {
                if (pixmap.getPixel(px, yy) & 0xff) >= minAlpha {
                    point = Vector2(Float(px), Float(yy))
                    addPoint(&hull, Vector2(Float(px) + adjust, Float(yy)))
                    break
                }
                yy += 1
            }
            px -= 1
        }

        if hull.count > 2 {
            removeNonConvexPoints(&hull, newTop: firstPoint)
        }
        return divideShape(hull, width: width, height: height)
    }

    private func addPoint(_ hull: inout [Vector2], _ point: Vector2) {
        removeNonConvexPoints(&hull, newTop: point)
        hull.append(point)
    }

    private func removeNonConvexPoints(_ hull: inout [Vector2], newTop: Vector2) {
        while hull.count > 1 {
            let top = hull[hull.count - 1]
            let secondTop = hull[hull.count - 2]
            if leftTurn(secondTop, top, newTop) { break }
            if top.y > newTop.y && top.y > secondTop.y { break }
            hull.removeLast()
        }
    }

    private func leftTurn(_ a: Vector2, _ b: Vector2, _ c: Vector2) -> Bool {
        return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x) < 0
    }

    private func polygon(_ points: [Vector2]) -> B2Shape? {
        var xy: [NSNumber] = []
        for p in points { xy.append(NSNumber(value: p.x)); xy.append(NSNumber(value: p.y)) }
        return B2Shape.polygon(vertices: xy)   // nil при <3 точек (Box2D в Java тут падает)
    }

    private func divideShape(_ input: [Vector2], width: Int, height: Int) -> [B2Shape]? {
        var convex = input
        for i in 0..<convex.count {
            var p = convex[i]
            p.x -= Float(width) / 2
            p.y = Float(height) / 2 - p.y
            convex[i] = PhysicsWorldConverter.convertCatroidToBox2dVector(p)
        }

        if convex.count < 9 {
            guard let poly = polygon(convex) else { return nil }
            return [poly]
        }

        var shapes: [B2Shape] = []
        let rome = convex[0]
        var index = 1
        while index < convex.count - 1 {
            var k = index + 7
            let remaining = convex.count - index
            if remaining > 7 && remaining < 9 { k -= 3 }

            var pointsPerShape: [Vector2] = [rome]
            while index < k && index < convex.count {
                pointsPerShape.append(convex[index])
                index += 1
            }
            if let poly = polygon(pointsPerShape) { shapes.append(poly) }
            index -= 1
        }
        return shapes
    }
}
