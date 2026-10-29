import Foundation
import CoreGraphics

public final class CollisionPolygonVertex: Hashable, CustomStringConvertible {
    public var startX: Float, startY: Float, endX: Float, endY: Float

    public init(_ startX: Float, _ startY: Float, _ endX: Float, _ endY: Float) {
        self.startX = startX; self.startY = startY; self.endX = endX; self.endY = endY
    }

    public func extend(_ x: Float, _ y: Float) { endX = x; endY = y }

    public func flip() {
        let xt = startX, yt = startY
        startX = endX; startY = endY
        endX = xt; endY = yt
    }

    public var startPoint: CGPoint { return CGPoint(x: CGFloat(startX), y: CGFloat(startY)) }
    public var endPoint: CGPoint { return CGPoint(x: CGFloat(endX), y: CGFloat(endY)) }

    /// Как в Java: при обратном соединении переворачивает ДРУГУЮ вершину
    public func isConnected(_ other: CollisionPolygonVertex) -> Bool {
        if other.startX == endX && other.startY == endY { return true }
        if isConnectedBackwards(other) { other.flip(); return true }
        return false
    }

    private func isConnectedBackwards(_ other: CollisionPolygonVertex) -> Bool {
        return other.endX == endX && other.endY == endY
    }

    public var description: String { return "\(startX)/\(startY) -> \(endX)/\(endY)" }

    public static func == (l: CollisionPolygonVertex, r: CollisionPolygonVertex) -> Bool {
        return l === r || (l.startX == r.startX && l.startY == r.startY && l.endX == r.endX && l.endY == r.endY)
    }
    public func hash(into hasher: inout Hasher) { hasher.combine(description) }
}
