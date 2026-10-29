import Foundation
import UIKit
import SpriteKit
import ImageIO
import UniformTypeIdentifiers
import os

/// XML: name и fileName — атрибуты.
open class LookData: Nameable, Hashable {

    private static let logger = Logger(subsystem: "org.catrobat.catroid", category: "LookData")
    private static let thumbnailWidth = 150
    private static let thumbnailHeight = 150

    public var name: String
    public private(set) var fileName: String?

    // transient
    public private(set) var file: URL!
    private var thumbnailImage: UIImage?
    public var width: Int?
    public var height: Int?
    var pixmapStorage: Pixmap?
    var textureRegionStorage: TextureRegion?
    private var collisionInfo: CollisionInformation?

    public private(set) var valid = true
    public var isWebRequest = false

    public init() {
        self.name = ""
    }

    public init(name: String, file: URL) {
        self.name = name
        self.file = file
        self.fileName = file.lastPathComponent
    }

    /// Только для XML-десериализации (getXstreamFileName в Java)
    public func xstreamFileName() -> String? {
        precondition(file == nil, "This should be used only to deserialize the Object. You should use file instead.")
        return fileName
    }

    public func setFile(_ file: URL) {
        self.file = file
        self.fileName = file.lastPathComponent
    }

    open func addRequiredResources(_ resourcesSet: ResourcesSet) {}

    open func dispose() {
        pixmapStorage?.dispose()
        pixmapStorage = nil
        textureRegionStorage = nil
    }

    // MARK: - Hashable (по файлу)

    public static func == (lhs: LookData, rhs: LookData) -> Bool {
        return lhs === rhs || (lhs.file != nil && lhs.file == rhs.file)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(file)
    }

    open func clone() -> LookData {
        do {
            return LookData(name: name, file: try StorageOperations.duplicateFile(file))
        } catch {
            fatalError("LookData: Could not copy file: \(file.path)")
        }
    }

    // MARK: - Texture / pixmap

    public func getTextureRegion() -> TextureRegion {
        if textureRegionStorage == nil {
            let pixmap = getPixmap()
            let texture = pixmap?.cgImage.map { SKTexture(cgImage: $0) } ?? SKTexture()
            textureRegionStorage = TextureRegion(texture: texture)
        }
        return textureRegionStorage!
    }

    public func setTextureRegion(_ region: TextureRegion?) {
        textureRegionStorage = region
    }

    public func getPixmap() -> Pixmap? {
        if pixmapStorage == nil {
            if let path = file?.path {
                pixmapStorage = Pixmap(path: path)
                if pixmapStorage == nil {
                    Self.logger.error("Couldn't load file: \(path)")
                    pixmapStorage = Pixmap(width: 1, height: 1)
                }
            }
        }
        return pixmapStorage
    }

    public func setPixmap(_ pixmap: Pixmap?) {
        pixmapStorage = pixmap
    }

    // MARK: - Thumbnail / measure

    public func getThumbnailBitmap() -> UIImage? {
        if thumbnailImage == nil, let file = file {
            thumbnailImage = ImageEditing.getScaledImage(fromPath: file.path,
                                                         width: Self.thumbnailWidth,
                                                         height: Self.thumbnailHeight,
                                                         resizeType: .stayInRectangleWithSameAspectRatio,
                                                         justScaleDown: false)
        }
        return thumbnailImage
    }

    public func invalidateThumbnailBitmap() {
        thumbnailImage = nil
    }

    /// Только заголовок файла, без декодирования (inJustDecodeBounds)
    public func getMeasure() -> (width: Int, height: Int) {
        var w = 0, h = 0
        if let src = CGImageSourceCreateWithURL(file as CFURL, nil),
           let props = CGImageSourceCopyPropertiesAtIndex(src, 0, nil) as? [CFString: Any] {
            w = props[kCGImagePropertyPixelWidth] as? Int ?? 0
            h = props[kCGImagePropertyPixelHeight] as? Int ?? 0
        }
        width = w
        height = h
        return (w, h)
    }

    public func getImageMimeType() -> String? {
        guard let src = CGImageSourceCreateWithURL(file as CFURL, nil),
              let uti = CGImageSourceGetType(src) else { return nil }
        return UTType(uti as String)?.preferredMIMEType
    }

    // MARK: - Collision

    public func clearCollisionInformation() {
        collisionInfo = nil
    }

    public var collisionInformation: CollisionInformation {
        if collisionInfo == nil {
            collisionInfo = CollisionInformation(lookData: self)
        }
        return collisionInfo!
    }

    // MARK: - Validity

    public var isValid: Bool { return valid }

    public func invalidate() {
        valid = false
    }
}
