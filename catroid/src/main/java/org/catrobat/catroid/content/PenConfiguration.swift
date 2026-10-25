import Foundation
import UIKit

public final class PenConfiguration {

    /// Queue<Queue<PointF>>
    public private(set) var positions: [[CGPoint]] = []
    private var penDown = false
    private var penSize: Double = BrickValues.penSize
    private var penColor = PenColor(0, 0, 1, 1)
    private var stamp = false
    private var queuesToFinish = 0

    public init() {}

    public func drawLinesForSprite(screenRatio: Float, camera: Camera) {
        guard let renderer = StageActivity.stageListener?.shapeRenderer else { return }
        renderer.color = UIColor(red: CGFloat(penColor.r), green: CGFloat(penColor.g),
                                 blue: CGFloat(penColor.b), alpha: CGFloat(penColor.a))
        renderer.begin()
        while currentQueueHasJobToHandle() {
            drawLine(screenRatio: screenRatio, renderer: renderer, camera: camera)
            updateQueues()
        }
        renderer.end()
    }

    private func currentQueueHasJobToHandle() -> Bool {
        return !positions.isEmpty && (positions[0].count > 1 || queuesToFinish > 0)
    }

    private func drawLine(screenRatio: Float, renderer: ShapeRenderer, camera: Camera) {
        let current = positions[0].removeFirst()
        let next = positions[0][0]          // first() — остаётся в очереди
        let cx = Float(current.x + camera.position.x), cy = Float(current.y + camera.position.y)
        let nx = Float(next.x + camera.position.x), ny = Float(next.y + camera.position.y)
        if cx != nx || cy != ny {
            let size = Float(penSize) * screenRatio
            renderer.circle(cx, cy, size / 2)
            renderer.rectLine(cx, cy, nx, ny, size)
            renderer.circle(nx, ny, size / 2)
        }
    }

    private func updateQueues() {
        if queuesToFinish > 0 && positions[0].count <= 1 {
            positions.removeFirst()
            queuesToFinish -= 1
        }
    }

    public func addQueue() { positions.append([]) }
    public func addPosition(_ p: CGPoint) {
        if positions.isEmpty { positions.append([]) }   // Java бросил бы исключение; здесь мягче
        positions[positions.count - 1].append(p)
    }
    public func incrementQueuesToFinish() { queuesToFinish += 1 }

    public func setPenDown(_ v: Bool) { penDown = v }
    public var isPenDown: Bool { return penDown }
    public func setPenSize(_ v: Double) { penSize = v }
    public func setPenColor(_ c: PenColor) { penColor = c }
    public func setStamp(_ v: Bool) { stamp = v }
    public func hasStamp() -> Bool { return stamp }
}
