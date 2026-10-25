import Foundation

private let equalityEpsilon: Float = 0.0000001

public struct Resolution: Equatable {
    public let width: Int
    public let height: Int
    public let offsetX: Int
    public let offsetY: Int

    public init(_ width: Int, _ height: Int, offsetX: Int = 0, offsetY: Int = 0) {
        precondition(width != 0, "Screen width may not be 0;")
        precondition(height != 0, "Screen height may not be 0;")
        self.width = width; self.height = height
        self.offsetX = offsetX; self.offsetY = offsetY
    }

    public var isInPortraitMode: Bool { return width < height }
    public var isInLandscapeMode: Bool { return !isInPortraitMode }
    public var aspectRatio: Float { return Float(width) / Float(height) }

    public func flipToFit(_ target: Resolution) -> Resolution {
        return doesOrientationMatch(target)
            ? Resolution(width, height, offsetX: offsetX, offsetY: offsetY)
            : Resolution(height, width, offsetX: offsetY, offsetY: offsetX)
    }
    public func flipToPortrait() -> Resolution { return flipToFit(Resolution(1, 2)) }
    public func flipToLandscape() -> Resolution { return flipToFit(Resolution(2, 1)) }

    private func doesOrientationMatch(_ target: Resolution) -> Bool {
        return (target.height > target.width && isInPortraitMode) ||
               (target.height < target.width && isInLandscapeMode)
    }

    public func resizeToFit(_ target: Resolution) -> Resolution {
        let ratioHeight = Float(target.height) / Float(height)
        let ratioWidth = Float(target.width) / Float(width)
        if aspectRatio < target.aspectRatio {
            let scale = ratioHeight / ratioWidth
            let newWidth = Int(Float(target.width) * scale)
            let hOffset = Int(Double(target.width - newWidth) / 2.0)
            return Resolution(newWidth, target.height, offsetX: hOffset, offsetY: 0)
        } else if aspectRatio > target.aspectRatio {
            let scale = ratioWidth / ratioHeight
            let newHeight = Int(Float(target.height) * scale)
            let vOffset = Int(Double(target.height - newHeight) / 2.0)
            return Resolution(target.width, newHeight, offsetX: 0, offsetY: vOffset)
        }
        return Resolution(target.width, target.height)
    }

    public func sameRatioOrMeasurements(_ target: Resolution) -> Bool {
        return (width == target.width && height == target.height) ||
               abs(aspectRatio - target.aspectRatio) < equalityEpsilon
    }
}
