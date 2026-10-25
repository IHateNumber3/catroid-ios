import Foundation
import UIKit
import SpriteKit

/// Замена gdx Pixmap: RGBA8888, начало координат в левом верхнем углу.
public final class Pixmap {
    public let width: Int
    public let height: Int
    private var data: [UInt8]
    private var cached: CGImage?

    public init(width: Int, height: Int) {
        self.width = max(1, width)
        self.height = max(1, height)
        self.data = [UInt8](repeating: 0, count: self.width * self.height * 4)
    }

    public init?(path: String) {
        guard let img = UIImage(contentsOfFile: path)?.cgImage else { return nil }
        width = img.width
        height = img.height
        data = [UInt8](repeating: 0, count: width * height * 4)
        let cs = CGColorSpaceCreateDeviceRGB()
        let info = CGImageAlphaInfo.premultipliedLast.rawValue
        let ok: Bool = data.withUnsafeMutableBytes { buf in
            guard let ctx = CGContext(data: buf.baseAddress, width: width, height: height,
                                      bitsPerComponent: 8, bytesPerRow: width * 4,
                                      space: cs, bitmapInfo: info) else { return false }
            ctx.draw(img, in: CGRect(x: 0, y: 0, width: width, height: height))
            return true
        }
        if !ok { return nil }
    }

    /// RGBA8888: (R<<24)|(G<<16)|(B<<8)|A
    public func getPixel(_ px: Int, _ py: Int) -> UInt32 {
        guard px >= 0, py >= 0, px < width, py < height else { return 0 }
        let i = (py * width + px) * 4
        return (UInt32(data[i]) << 24) | (UInt32(data[i + 1]) << 16) | (UInt32(data[i + 2]) << 8) | UInt32(data[i + 3])
    }

    public var cgImage: CGImage? {
        if let c = cached { return c }
        var copy = data
        let cs = CGColorSpaceCreateDeviceRGB()
        let info = CGImageAlphaInfo.premultipliedLast.rawValue
        let img: CGImage? = copy.withUnsafeMutableBytes { buf in
            guard let ctx = CGContext(data: buf.baseAddress, width: width, height: height,
                                      bitsPerComponent: 8, bytesPerRow: width * 4,
                                      space: cs, bitmapInfo: info) else { return nil }
            return ctx.makeImage()
        }
        cached = img
        return img
    }

    /// Масштабирование NearestNeighbour (Pixmap.drawPixmap + Filter.NearestNeighbour)
    public func scaledNearest(width newWidth: Int, height newHeight: Int) -> Pixmap {
        let out = Pixmap(width: newWidth, height: newHeight)
        for dy in 0..<out.height {
            let sy = min(height - 1, Int(Float(dy) * Float(height) / Float(out.height)))
            for dx in 0..<out.width {
                let sx = min(width - 1, Int(Float(dx) * Float(width) / Float(out.width)))
                let si = (sy * width + sx) * 4
                let di = (dy * out.width + dx) * 4
                out.data[di] = data[si]; out.data[di + 1] = data[si + 1]
                out.data[di + 2] = data[si + 2]; out.data[di + 3] = data[si + 3]
            }
        }
        return out
    }

    public func dispose() { cached = nil }
}

/// Замена TextureRegion: текстура + флаги flip (хранятся в LookData, как в Java).
public final class TextureRegion {
    public let texture: SKTexture
    public private(set) var isFlipX = false
    public private(set) var isFlipY = false

    public init(texture: SKTexture) { self.texture = texture }

    public func flip(x: Bool, y: Bool) {
        if x { isFlipX.toggle() }
        if y { isFlipY.toggle() }
    }
}
