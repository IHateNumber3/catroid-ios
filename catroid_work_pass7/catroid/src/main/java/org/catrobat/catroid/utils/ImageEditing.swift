import Foundation
import UIKit
import ImageIO
import os

public enum ImageEditing {

    public enum ResizeType {
        case stretchToRectangle
        case stayInRectangleWithSameAspectRatio
        case fillRectangleWithSameAspectRatio
    }

    private static let logger = Logger(subsystem: "org.catrobat.catroid", category: "ImageEditing")
    private static let jpgCompressionSetting: CGFloat = 0.95
    private static let metaLock = NSLock()

    private static func scaleImage(_ image: UIImage?, xSize: Int, ySize: Int) -> UIImage? {
        guard let image = image, let cg = image.cgImage else { return nil }
        let size = CGSize(width: xSize, height: ySize)
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        _ = cg
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }

    public static func getScaledImage(fromPath imagePath: String?, width outW: Int, height outH: Int,
                                      resizeType: ResizeType, justScaleDown: Bool) -> UIImage? {
        guard let imagePath = imagePath else { return nil }
        let dims = getImageDimensions(imagePath)
        let (newW, newH) = getScaledImageDimensions(dims.width, dims.height, outW, outH, resizeType, justScaleDown)
        let sample = calculateInSampleSize(dims.width, dims.height, outW, outH)

        // inSampleSize → уменьшенная декодировка через ImageIO
        var temp: UIImage?
        if sample > 1, let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: imagePath) as CFURL, nil) {
            let opts: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: max(dims.width, dims.height) / sample
            ]
            if let cg = CGImageSourceCreateThumbnailAtIndex(src, 0, opts as CFDictionary) {
                temp = UIImage(cgImage: cg)
            }
        }
        if temp == nil { temp = UIImage(contentsOfFile: imagePath) }
        return scaleImage(temp, xSize: newW, ySize: newH)
    }

    /// inJustDecodeBounds: только заголовок
    public static func getImageDimensions(_ imagePath: String) -> (width: Int, height: Int) {
        guard let src = CGImageSourceCreateWithURL(URL(fileURLWithPath: imagePath) as CFURL, nil),
              let props = CGImageSourceCopyPropertiesAtIndex(src, 0, nil) as? [CFString: Any] else { return (0, 0) }
        return (props[kCGImagePropertyPixelWidth] as? Int ?? 0, props[kCGImagePropertyPixelHeight] as? Int ?? 0)
    }

    private static func getScaledImageDimensions(_ originalW: Int, _ originalH: Int, _ outW: Int, _ outH: Int,
                                                 _ type: ResizeType, _ justScaleDown: Bool) -> (Int, Int) {
        var newW = originalW, newH = originalH
        let sw = Double(originalW) / Double(outW)
        let sh = Double(originalH) / Double(outH)
        let smin = min(sw, sh), smax = max(sw, sh)
        if !justScaleDown || originalH >= outH || originalW >= outW {
            switch type {
            case .stretchToRectangle:
                newW = outW; newH = outH
            case .stayInRectangleWithSameAspectRatio:
                newW = Int((Double(originalW) / smax).rounded(.down))
                newH = Int((Double(originalH) / smax).rounded(.down))
            case .fillRectangleWithSameAspectRatio:
                newW = Int((Double(originalW) / smin).rounded(.down))
                newH = Int((Double(originalH) / smin).rounded(.down))
            }
        }
        return (max(newW, 1), max(newH, 1))
    }

    public static func rotateImage(_ image: UIImage, degrees: Int) -> UIImage {
        let radians = CGFloat(degrees) * .pi / 180
        let rotated = CGRect(origin: .zero, size: image.size).applying(CGAffineTransform(rotationAngle: radians))
        let size = CGSize(width: abs(rotated.width), height: abs(rotated.height))
        let format = UIGraphicsImageRendererFormat.default(); format.scale = 1
        return UIGraphicsImageRenderer(size: size, format: format).image { ctx in
            ctx.cgContext.translateBy(x: size.width / 2, y: size.height / 2)
            ctx.cgContext.rotate(by: radians)
            image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2,
                                  width: image.size.width, height: image.size.height))
        }
    }

    public static func scaleImageFile(_ file: URL, scaleFactor: Double) throws {
        let d = getImageDimensions(file.path)
        try scaleImageFile(file, width: Int(Double(d.width) * scaleFactor), height: Int(Double(d.height) * scaleFactor))
    }

    public static func scaleImageFile(_ file: URL, width: Int, height: Int) throws {
        let scaled = getScaledImage(fromPath: file.path, width: width, height: height,
                                    resizeType: .fillRectangleWithSameAspectRatio, justScaleDown: false)
        try saveImageToFile(file, image: scaled)
    }

    public static func calculateScaleFactor(originalWidth: Int, originalHeight: Int, newWidth: Int, newHeight: Int) -> Double {
        precondition(originalWidth != 0 && originalHeight != 0 && newWidth != 0 && newHeight != 0, "One or more values are 0")
        return max(Double(newWidth) / Double(originalWidth), Double(newHeight) / Double(originalHeight))
    }

    private static func calculateInSampleSize(_ origW: Int, _ origH: Int, _ reqW: Int, _ reqH: Int) -> Int {
        var sample = 1
        if origH > reqH || origW > reqW {
            let halfH = origH / 2, halfW = origW / 2
            while halfH / sample > reqH && halfW / sample > reqW { sample *= 2 }
        }
        return sample
    }

    public static func saveImageToFile(_ outputFile: URL, image: UIImage?) throws {
        guard let image = image else { return }
        let ext = outputFile.pathExtension.lowercased()
        let data: Data?
        if ext == "jpg" || ext == "jpeg" {
            data = image.jpegData(compressionQuality: jpgCompressionSetting)
        } else {
            data = image.pngData()
        }
        if let data = data { try data.write(to: outputFile) }
    }

    // MARK: - PNG metadata

    /// nil — файл не удалось прочитать как PNG (PngjInputException)
    public static func readMetaDataStringFromPNG(_ path: String, key: String) -> String? {
        return PNGMetadata.readText(path: path, key: key)
    }

    public static func writeMetaDataStringToPNG(_ path: String, key: String, value: String) {
        metaLock.lock(); defer { metaLock.unlock() }
        if !PNGMetadata.writeText(path: path, key: key, value: value) {
            logger.error("writeMetaDataStringToPNG: failed")
        }
    }

    /// Color.TRANSPARENT: слово RGBA8888 (premultiplied) целиком равно 0
    public static func isPixelTransparent(_ pixmap: Pixmap, x: Int, y: Int) -> Bool {
        return pixmap.getPixel(x, y) == 0
    }
}
