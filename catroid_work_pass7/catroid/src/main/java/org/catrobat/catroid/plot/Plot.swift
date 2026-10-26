import Foundation
import UIKit

public final class Plot {
    public private(set) var isPlotting = false
    public private(set) var isEngraving = false
    public private(set) var isCutting = false

    public var plotDataPointLists: [[CGPoint]] = []
    private var plotQueue: [[CGPoint]] = []
    public var engraveDataPointLists: [[CGPoint]] = []
    private var engraveQueue: [[CGPoint]] = []
    public var cutDataPointLists: [[CGPoint]] = []
    private var cutQueue: [[CGPoint]] = []

    public var width: Float = 0
    public var height: Float = 0

    public init() {}

    public func pausePlot() { isPlotting = false }
    public func resumePlot() { isPlotting = true }
    public func pauseCut() { isCutting = false }
    public func resumeCut() { isCutting = true }
    public func pauseEngrave() { isEngraving = false }
    public func resumeEngrave() { isEngraving = true }

    private func startLine(_ data: inout [[CGPoint]], _ queue: inout [[CGPoint]]) {
        data.append([])
        queue.append([])
    }

    private func startNewLine(_ point: CGPoint, _ data: inout [[CGPoint]], _ queue: inout [[CGPoint]]) {
        data.append([point])
        queue.append([point])
    }

    private func addPoint(_ point: CGPoint, _ data: inout [[CGPoint]], _ queue: inout [[CGPoint]]) {
        if data.isEmpty { data.append([]) }
        if queue.isEmpty { queue.append([]) }
        data[data.count - 1].append(point)
        queue[queue.count - 1].append(point)
    }

    public func startNewPlotLine() { startLine(&plotDataPointLists, &plotQueue) }
    public func startNewPlotLine(_ p: CGPoint) { startNewLine(p, &plotDataPointLists, &plotQueue) }
    public func addPlotPoint(_ p: CGPoint) { addPoint(p, &plotDataPointLists, &plotQueue) }
    public func startNewCutLine(_ p: CGPoint) { startNewLine(p, &cutDataPointLists, &cutQueue) }
    public func addCutPoint(_ p: CGPoint) { addPoint(p, &cutDataPointLists, &cutQueue) }
    public func startNewEngraveLine(_ p: CGPoint) { startNewLine(p, &engraveDataPointLists, &engraveQueue) }
    public func addEngravePoint(_ p: CGPoint) { addPoint(p, &engraveDataPointLists, &engraveQueue) }

    public func data() -> [[CGPoint]] { return plotDataPointLists }

    private func canRender(_ queue: inout [[CGPoint]]) -> Bool {
        while queue.count > 1 && queue[0].count <= 1 { queue.removeFirst() }
        return !queue.isEmpty && queue[0].count > 1
    }

    public func drawLinesForSprite(screenRatio: Float, camera: Camera?) {
        guard let camera = camera, let renderer = StageActivity.stageListener?.shapeRenderer else { return }

        renderer.color = .black
        renderer.begin()
        while canRender(&plotQueue) { drawLine(&plotQueue, screenRatio, renderer, camera) }
        renderer.end()

        renderer.color = .red
        renderer.begin()
        while canRender(&cutQueue) { drawLine(&cutQueue, screenRatio, renderer, camera) }
        renderer.end()

        renderer.color = .blue
        renderer.begin()
        while canRender(&engraveQueue) { drawLine(&engraveQueue, screenRatio, renderer, camera) }
        renderer.end()

        width = camera.viewportWidth
        height = camera.viewportHeight
    }

    private func drawLine(_ queue: inout [[CGPoint]], _ screenRatio: Float, _ renderer: ShapeRenderer, _ camera: Camera) {
        let current = queue[0].removeFirst()
        let next = queue[0][0]
        let cx = Float(current.x + camera.position.x), cy = Float(current.y + camera.position.y)
        let nx = Float(next.x + camera.position.x), ny = Float(next.y + camera.position.y)
        if cx != nx || cy != ny {
            let penSize = screenRatio * 2.0
            renderer.circle(cx, cy, penSize / 2)
            renderer.rectLine(cx, cy, nx, ny, penSize)
            renderer.circle(nx, ny, penSize / 2)
        }
    }
}
