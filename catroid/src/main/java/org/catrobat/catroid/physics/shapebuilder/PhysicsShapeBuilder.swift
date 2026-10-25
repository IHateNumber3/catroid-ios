import Foundation
import os

public final class PhysicsShapeBuilder {

    public enum ShapeBuilderError: Error {
        case invalidScaleFactor
        case nullLookData
    }

    private static let logger = Logger(subsystem: "org.catrobat.catroid", category: "PhysicsShapeBuilder")
    private static let accuracyLevels: [Float] = [0.125, 0.25, 0.50, 0.75, 1.0]

    public static let shared = PhysicsShapeBuilder()

    private var strategy: PhysicsShapeBuilderStrategy = PhysicsShapeBuilderStrategyFastHull()
    private var imageShapesMap: [String: ImageShapes] = [:]
    private let lock = NSLock()

    private init() {}

    public func reset() {
        lock.lock(); defer { lock.unlock() }
        strategy = PhysicsShapeBuilderStrategyFastHull()
        imageShapesMap = [:]
    }

    public func getScaledShapes(_ lookData: LookData, scaleFactor: Float) -> [B2Shape]? {
        lock.lock(); defer { lock.unlock() }
        if scaleFactor < 0 {
            preconditionFailure("scaleFactor can not be smaller than 0")
        }
        guard let pixmap = lookData.getPixmap() else {
            Self.logger.error("pixmap should not be null")
            return nil
        }
        let identifier = Utils.md5Checksum(lookData.file)
        if imageShapesMap[identifier] == nil {
            imageShapesMap[identifier] = ImageShapes(pixmap: pixmap)
        }
        let accuracy = Self.getAccuracyLevel(scaleFactor)
        guard let shapes = imageShapesMap[identifier]!.getShapes(accuracy, strategy: strategy) else {
            Self.logger.error("shapes should not be null")
            return nil
        }
        return PhysicsShapeScaleUtils.scaleShapes(shapes, targetScale: scaleFactor)
    }

    private static func getAccuracyLevel(_ scaleFactor: Float) -> Float {
        if accuracyLevels.isEmpty { return 0 }
        if accuracyLevels.count == 1 { return accuracyLevels[0] }
        for i in 0..<(accuracyLevels.count - 1) {
            let average = (accuracyLevels[i] + accuracyLevels[i]) / 2   // как в Java
            if scaleFactor < average { return accuracyLevels[i] }
        }
        return accuracyLevels[accuracyLevels.count - 1]
    }

    /// Кэш форм одного изображения для разных уровней точности (база — 100%)
    private final class ImageShapes {
        private static let maxOriginalPixmapSize = 512
        private var shapeMap: [String: [B2Shape]] = [:]
        private let pixmap: Pixmap
        private var sizeAdjustmentScaleFactor: Float = 1

        init(pixmap: Pixmap) {
            self.pixmap = pixmap
            let w = pixmap.width, h = pixmap.height
            let maxSize = Self.maxOriginalPixmapSize
            if w > maxSize || h > maxSize {
                sizeAdjustmentScaleFactor = w > h ? Float(maxSize) / Float(w) : Float(maxSize) / Float(h)
            }
        }

        private func shapeKey(_ accuracy: Float) -> String { return String(Int(accuracy * 100)) }

        private func computeNewShape(_ accuracy: Float, strategy: PhysicsShapeBuilderStrategy) -> [B2Shape]? {
            let w = pixmap.width, h = pixmap.height
            var scaledW = Int((Float(w) * sizeAdjustmentScaleFactor * accuracy + 0.5).rounded(.down))
            var scaledH = Int((Float(h) * sizeAdjustmentScaleFactor * accuracy + 0.5).rounded(.down))
            if scaledW < 1 { scaledW = 1 }
            if scaledH < 1 { scaledH = 1 }
            let scaledPixmap = pixmap.scaledNearest(width: scaledW, height: scaledH)
            let scaledShapes = strategy.build(pixmap: scaledPixmap, scale: 1.0)
            return PhysicsShapeScaleUtils.scaleShapes(scaledShapes, targetScale: 1.0,
                                                      originScale: sizeAdjustmentScaleFactor * accuracy)
        }

        func getShapes(_ accuracy: Float, strategy: PhysicsShapeBuilderStrategy) -> [B2Shape]? {
            let key = shapeKey(accuracy)
            if shapeMap[key] == nil {
                guard let shapes = computeNewShape(accuracy, strategy: strategy) else { return nil }
                shapeMap[key] = shapes
            }
            return shapeMap[key]
        }
    }
}
