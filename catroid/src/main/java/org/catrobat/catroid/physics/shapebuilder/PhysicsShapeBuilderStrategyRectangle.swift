import Foundation

public final class PhysicsShapeBuilderStrategyRectangle: PhysicsShapeBuilderStrategy {

    public init() {}

    public func build(pixmap: Pixmap?, scale: Float) -> [B2Shape]? {
        guard let pixmap = pixmap else { return nil }
        var start: (x: Int, y: Int)?
        var end: (x: Int, y: Int)?

        for y in 0..<pixmap.height {
            for x in 0..<pixmap.width {
                let alpha = pixmap.getPixel(x, y) & 0xff
                if alpha > 0 {
                    if start == nil {
                        start = (x, y)
                        end = (x, y)
                        continue
                    }
                    if x < start!.x { start!.x = x } else if x > end!.x { end!.x = x }
                    if y < start!.y { start!.y = y } else if y > end!.y { end!.y = y }
                }
            }
        }
        guard let s = start, let e = end else { return nil }

        var width = e.x - s.x
        var height = e.y - s.y
        if width == 0 { width = 1 }
        if height == 0 { height = 1 }

        let box2dWidth = PhysicsWorldConverter.convertNormalToBox2dCoordinate(Float(width)) / 2
        let box2dHeight = PhysicsWorldConverter.convertNormalToBox2dCoordinate(Float(height)) / 2
        let center = CGPoint(
            x: CGFloat(box2dWidth - PhysicsWorldConverter.convertNormalToBox2dCoordinate(Float(pixmap.width) / 2)),
            y: CGFloat(box2dHeight - PhysicsWorldConverter.convertNormalToBox2dCoordinate(Float(pixmap.height) / 2)))
        return [B2Shape.box(halfWidth: box2dWidth, halfHeight: box2dHeight, center: center, angle: 0)]
    }
}
