import Foundation
import CoreGraphics
import os

public final class CollisionInformation {

    private static let logger = Logger(subsystem: "org.catrobat.catroid", category: "CollisionInformation")

    public var collisionPolygons: [Polygon]?
    var isCalculationThreadCancelled = true
    private unowned let lookData: LookData
    public private(set) var leftBubblePos: (Int, Int)?
    public private(set) var rightBubblePos: (Int, Int)?

    public init(lookData: LookData) {
        self.lookData = lookData
    }

    /// Фоновый расчёт (CollisionPolygonCreationTask)
    public func calculate() {
        isCalculationThreadCancelled = false
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.loadCollisionPolygon()
        }
    }

    public var numberOfVertices: Int {
        return (collisionPolygons ?? []).reduce(0) { $0 + $1.vertices.count / 2 }
    }

    // MARK: - Bubble positions

    public func calculateBubblePositions() {
        guard let pixmap = Pixmap(path: lookData.file.path) else { return }
        calculateBubblePositions(pixmap)
    }

    public func calculateBubblePositions(_ pixmap: Pixmap) {
        let centerX = pixmap.width / 2
        let centerY = pixmap.height / 2
        for y in 0..<pixmap.height {
            if rightBubblePos != nil { return }
            var x = pixmap.width - 1
            while x > 0 {
                if !ImageEditing.isPixelTransparent(pixmap, x: x, y: y) {
                    let xDiff = x - centerX
                    let yDiff = centerY - y
                    if rightBubblePos == nil { rightBubblePos = (xDiff, yDiff) }
                    leftBubblePos = (xDiff, yDiff)
                }
                x -= 1
            }
        }
    }

    // MARK: - Load / create

    public func loadCollisionPolygon() {
        isCalculationThreadCancelled = false
        let path = lookData.file.path
        if lookData.getImageMimeType() != "image/png" {
            if let pixmap = Pixmap(path: path) { collisionPolygons = Self.createCollisionPolygonByHitbox(pixmap) }
            return
        }
        collisionPolygons = Self.getCollisionPolygonFromPNGMeta(path)
        if collisionPolygons?.isEmpty ?? true {
            createCollisionPolygon(path)
        }
    }

    private func createCollisionPolygon(_ path: String) {
        Self.logger.info("No Collision information from PNG file, creating new one.")
        if isCalculationThreadCancelled { return }

        let boundingPolygon = Self.createBoundingPolygonVertices(path, lookData)
        if boundingPolygon.isEmpty { return }

        var epsilon = Constants.collisionPolygonCreationEpsilon
        repeat {
            if isCalculationThreadCancelled { return }
            var temporary: [Polygon] = []
            for vertices in boundingPolygon {
                if isCalculationThreadCancelled { return }
                let points = Self.getPointsFromPolygonVertices(vertices)
                var simplified = Self.simplifyPolygon(points, 0, points.count - 1, epsilon)
                let dx = Float(simplified[simplified.count - 1].x - simplified[0].x)
                let dy = Float(simplified[simplified.count - 1].y - simplified[0].y)
                if Float(hypot(Double(dx), Double(dy))) < epsilon {
                    simplified.removeLast()
                }
                if simplified.count < 3 { continue }
                temporary.append(Self.createPolygonFromPoints(simplified))
            }
            collisionPolygons = temporary
            epsilon *= 1.2
        } while numberOfVertices > Constants.collisionVertexLimit

        if collisionPolygons?.isEmpty ?? true, let pixmap = Pixmap(path: path) {
            collisionPolygons = Self.createCollisionPolygonByHitbox(pixmap)
        }
        if isCalculationThreadCancelled || !lookData.isValid { return }
        Self.writeCollisionVerticesToPNGMeta(collisionPolygons ?? [], path)
        Self.logger.info("Polygon size of look \(self.lookData.name): \(self.numberOfVertices)")
    }

    // MARK: - Bounding polygon

    public static func createBoundingPolygonVertices(_ absoluteBitmapPath: String, _ lookData: LookData) -> [[CollisionPolygonVertex]] {
        guard let pixmap = Pixmap(path: absoluteBitmapPath) else {
            logger.error("bitmap \(absoluteBitmapPath) is null. Cannot create Collision polygon")
            return []
        }
        let grid = createCollisionGrid(pixmap)       // уже перевёрнут по Y (preScale(1,-1))
        let w = pixmap.width, h = pixmap.height
        let info = lookData.collisionInformation
        if info.isCalculationThreadCancelled { return [] }

        var vertical = createVerticalVertices(grid, w, h)
        var horizontal = createHorizontalVertices(grid, w, h)
        if vertical.isEmpty || horizontal.isEmpty { return [] }
        if info.isCalculationThreadCancelled { return [] }

        var finalVertices: [[CollisionPolygonVertex]] = [[]]
        var polygonNumber = 0
        finalVertices[0].append(vertical.removeFirst())

        repeat {
            if info.isCalculationThreadCancelled { return [] }
            var end = finalVertices[polygonNumber].last!
            var found = false

            for hIndex in 0..<horizontal.count {
                if end.isConnected(horizontal[hIndex]) {
                    finalVertices[polygonNumber].append(horizontal[hIndex])
                    end = horizontal[hIndex]
                    horizontal.remove(at: hIndex)
                    found = true
                    break
                }
            }
            for vIndex in 0..<vertical.count {
                if end.isConnected(vertical[vIndex]) {
                    finalVertices[polygonNumber].append(vertical[vIndex])
                    vertical.remove(at: vIndex)
                    found = true
                    break
                }
            }
            if !found {
                polygonNumber += 1
                finalVertices.append([])
                if vertical.isEmpty { break }
                finalVertices[polygonNumber].append(vertical.removeFirst())
            }
        } while !horizontal.isEmpty
        return finalVertices
    }

    public static func createHorizontalVertices(_ grid: [[Bool]], _ gridWidth: Int, _ gridHeight: Int) -> [CollisionPolygonVertex] {
        var horizontal: [CollisionPolygonVertex] = []
        for y in 0..<gridHeight {
            for x in 0..<gridWidth where grid[x][y] {
                let topEdge = y == 0 || !grid[x][y - 1]
                if topEdge {
                    let extendPrevious = horizontal.count > 0
                        && horizontal[horizontal.count - 1].endX == Float(x) && horizontal[horizontal.count - 1].endY == Float(y)
                    let extendOther = horizontal.count > 1
                        && horizontal[horizontal.count - 2].endX == Float(x) && horizontal[horizontal.count - 2].endY == Float(y)
                    if extendPrevious {
                        horizontal[horizontal.count - 1].extend(Float(x + 1), Float(y))
                    } else if extendOther {
                        horizontal[horizontal.count - 2].extend(Float(x + 1), horizontal[horizontal.count - 2].endY)
                    } else {
                        horizontal.append(CollisionPolygonVertex(Float(x), Float(y), Float(x + 1), Float(y)))
                    }
                }
                let bottomEdge = y == gridHeight - 1 || !grid[x][y + 1]
                if bottomEdge {
                    let extendPrevious = horizontal.count > 0
                        && horizontal[horizontal.count - 1].endX == Float(x) && horizontal[horizontal.count - 1].endY == Float(y + 1)
                    let extendOther = horizontal.count > 1
                        && horizontal[horizontal.count - 2].endX == Float(x) && horizontal[horizontal.count - 2].endY == Float(y + 1)
                    if extendPrevious {
                        horizontal[horizontal.count - 1].extend(Float(x + 1), Float(y + 1))
                    } else if extendOther {
                        horizontal[horizontal.count - 2].extend(Float(x + 1), horizontal[horizontal.count - 2].endY)
                    } else {
                        horizontal.append(CollisionPolygonVertex(Float(x), Float(y + 1), Float(x + 1), Float(y + 1)))
                    }
                }
            }
        }
        return horizontal
    }

    public static func createVerticalVertices(_ grid: [[Bool]], _ gridWidth: Int, _ gridHeight: Int) -> [CollisionPolygonVertex] {
        var vertical: [CollisionPolygonVertex] = []
        for x in 0..<gridWidth {
            for y in 0..<gridHeight where grid[x][y] {
                let leftEdge = x == 0 || !grid[x - 1][y]
                if leftEdge {
                    let extendPrevious = vertical.count > 0
                        && vertical[vertical.count - 1].endX == Float(x) && vertical[vertical.count - 1].endY == Float(y)
                    let extendOther = vertical.count > 1
                        && vertical[vertical.count - 2].endX == Float(x) && vertical[vertical.count - 2].endY == Float(y)
                    if extendPrevious {
                        vertical[vertical.count - 1].extend(vertical[vertical.count - 1].endX, Float(y + 1))
                    } else if extendOther {
                        vertical[vertical.count - 2].extend(vertical[vertical.count - 2].endX, Float(y + 1))
                    } else {
                        vertical.append(CollisionPolygonVertex(Float(x), Float(y), Float(x), Float(y + 1)))
                    }
                }
                let rightEdge = x == gridWidth - 1 || !grid[x + 1][y]
                if rightEdge {
                    let extendPrevious = vertical.count > 0
                        && vertical[vertical.count - 1].endX == Float(x + 1) && vertical[vertical.count - 1].endY == Float(y)
                    let extendOther = vertical.count > 1
                        && vertical[vertical.count - 2].endX == Float(x + 1) && vertical[vertical.count - 2].endY == Float(y)
                    if extendPrevious {
                        vertical[vertical.count - 1].extend(vertical[vertical.count - 1].endX, Float(y + 1))
                    } else if extendOther {
                        vertical[vertical.count - 2].extend(vertical[vertical.count - 2].endX, Float(y + 1))
                    } else {
                        vertical.append(CollisionPolygonVertex(Float(x + 1), Float(y), Float(x + 1), Float(y + 1)))
                    }
                }
            }
        }
        return vertical
    }

    // MARK: - Douglas–Peucker

    private static func pointToLineDistance(_ s: CGPoint, _ e: CGPoint, _ p: CGPoint) -> Float {
        let normalLength = Float(((e.x - s.x) * (e.x - s.x) + (e.y - s.y) * (e.y - s.y)).squareRoot())
        return abs(Float((p.x - s.x) * (e.y - s.y) - (p.y - s.y) * (e.x - s.x))) / normalLength
    }

    public static func simplifyPolygon(_ points: [CGPoint], _ start: Int, _ end: Int, _ epsilon: Float) -> [CGPoint] {
        var dmax: Float = 0
        var index = start
        var i = index + 1
        while i < end {
            let d = pointToLineDistance(points[start], points[end], points[i])
            if d > dmax { index = i; dmax = d }
            i += 1
        }
        var result: [CGPoint] = []
        if dmax > epsilon {
            let r1 = simplifyPolygon(points, start, index, epsilon)
            let r2 = simplifyPolygon(points, index, end, epsilon)
            result.append(contentsOf: r1.dropLast())
            result.append(contentsOf: r2)
        } else {
            result.append(points[start])
            result.append(points[end])
        }
        return result
    }

    public static func getPointsFromPolygonVertices(_ polygon: [CollisionPolygonVertex]) -> [CGPoint] {
        return polygon.map { $0.startPoint }
    }

    public static func createPolygonFromPoints(_ points: [CGPoint]) -> Polygon {
        var nodes: [Float] = []
        nodes.reserveCapacity(points.count * 2)
        for p in points { nodes.append(Float(p.x)); nodes.append(Float(p.y)) }
        return Polygon(nodes)
    }

    /// Сетка [x][y]; y перевёрнут (Java разворачивал bitmap по вертикали)
    public static func createCollisionGrid(_ pixmap: Pixmap) -> [[Bool]] {
        let w = pixmap.width, h = pixmap.height
        var grid = [[Bool]](repeating: [Bool](repeating: false, count: h), count: w)
        for x in 0..<w {
            for y in 0..<h where !ImageEditing.isPixelTransparent(pixmap, x: x, y: h - 1 - y) {
                grid[x][y] = true
            }
        }
        return grid
    }

    // MARK: - PNG meta

    public static func writeCollisionVerticesToPNGMeta(_ polygons: [Polygon], _ absolutePath: String) {
        var meta = ""
        for polygon in polygons {
            meta += polygon.vertices.map { "\($0)" }.joined(separator: ";")
            meta += "|"
        }
        if !meta.isEmpty {
            meta.removeLast()
            ImageEditing.writeMetaDataStringToPNG(absolutePath, key: Constants.collisionPngMetaTagKey, value: meta)
        }
    }

    public static func getCollisionPolygonFromPNGMeta(_ absolutePath: String) -> [Polygon] {
        guard let metadata = ImageEditing.readMetaDataStringFromPNG(absolutePath, key: Constants.collisionPngMetaTagKey) else {
            logger.error("Error reading metadata from png!")
            return []
        }
        if !checkMetaDataString(metadata) { return [] }

        var result: [Polygon] = []
        for polygonString in metadata.split(separator: "|", omittingEmptySubsequences: true) {
            let points = polygonString.split(separator: ";").compactMap { Float($0) }
            result.append(Polygon(points))
        }
        logger.info("Loaded CollisionPolygon from \(absolutePath) successfully!")
        return result
    }

    public static func checkMetaDataString(_ metadata: String?) -> Bool {
        guard let metadata = metadata, !metadata.isEmpty,
              let regex = try? NSRegularExpression(pattern: Constants.collisionPolygonMetadataPattern) else { return false }
        let full = NSRange(metadata.startIndex..., in: metadata)
        if let m = regex.firstMatch(in: metadata, range: full), m.range == full { return true }
        logger.error("Invalid Metadata, creating new Polygon")
        return false
    }

    public static func createCollisionPolygonByHitbox(_ pixmap: Pixmap) -> [Polygon] {
        let w = Float(pixmap.width), h = Float(pixmap.height)
        return [Polygon([0, 0, w, 0, w, h, 0, h])]
    }
}
