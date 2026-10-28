import Foundation
import UIKit

public protocol ScreenshotSaverCallback: AnyObject {
    func screenshotSaved(success: Bool)
}

public class ScreenshotSaver {
    private static let tag = "ScreenshotSaver"
    private static let imageQuality: CGFloat = 1.0 // 100% качество для PNG
    private static let maxScreenshotHeight: CGFloat = 480.0
    private static let maxScreenshotWidth: CGFloat = 480.0
    private static let numberOfColors = 4
    
    // Регулярные выражения для валидации имени файла (аналоги Kotlin)
    private static let validFilenameRegex = try! NSRegularExpression(pattern: "^[^<>:;,?\"*|/]+$")
    private static let onlyWhitespaceRegex = try! NSRegularExpression(pattern: "\\s*")
    
    private let folder: String
    private let width: Int
    private let height: Int
    
    public init(folder: String, width: Int, height: Int) {
        self.folder = folder
        self.width = width
        self.height = height
    }
    
    public func saveScreenshotAndNotify(
        data: Data?,
        fileName: String?,
        callback: ScreenshotSaverCallback?
    ) {
        guard let data = data else {
            print("[\(ScreenshotSaver.tag)] Screenshot data is null")
            callback?.screenshotSaved(success: false)
            return
        }
        
        guard let fileName = fileName,
              !fileName.isEmpty,
              !fileName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              ScreenshotSaver.validFilenameRegex.firstMatch(in: fileName, range: NSRange(fileName.startIndex..., in: fileName)) != nil else {
            print("[\(ScreenshotSaver.tag)] Screenshot filename invalid")
            callback?.screenshotSaved(success: false)
            return
        }
        
        // Асинхронное сохранение в фоновом потоке (аналог CoroutineScope Dispatchers.IO)
        Task.detached(priority: .background) {
            let success = self.saveScreenshot(data: data, fileName: fileName)
            DispatchQueue.main.async {
                callback?.screenshotSaved(success: success)
            }
        }
    }
    
    private func saveScreenshot(data: Data, fileName: String) -> Bool {
        let length = data.count
        let colorCount = length / ScreenshotSaver.numberOfColors
        
        guard colorCount == width * height, colorCount > 0 else {
            return false
        }
        
        // Превращаем байты в массив RGBA пикселей
        var pixels = [UInt32](repeating: 0, count: colorCount)
        data.withUnsafeBytes { ptr in
            guard let baseAddress = ptr.baseAddress else { return }
            let bytes = baseAddress.assumingMemoryBound(to: UInt8.self) // или UInt8
            for i in stride(from: 0, to: length, by: ScreenshotSaver.numberOfColors) {
                let r = UInt32(bytes[i])
                let g = UInt32(bytes[i + 1])
                let b = UInt32(bytes[i + 2])
                let a: UInt32 = 255
                
                // ARGB формат для CoreGraphics
                pixels[i / ScreenshotSaver.numberOfColors] = (a << 24) | (r << 16) | (g << 8) | b
            }
        }
        
        // Создаем UIImage из пикселей
        guard let fullScreenImage = createImage(from: pixels, width: width, height: height) else {
            return false
        }
        
        // Вычисление пропорций для уменьшенного скриншота
        let aspectRatio = Double(width) / Double(height)
        var newWidth = CGFloat(Double(ScreenshotSaver.maxScreenshotHeight) * aspectRatio)
        if newWidth > ScreenshotSaver.maxScreenshotWidth {
            newWidth = ScreenshotSaver.maxScreenshotWidth
        }
        
        let resizedImage = fullScreenImage.scaledToFit(CGSize(width: newWidth, height: ScreenshotSaver.maxScreenshotHeight))
        
        // Пути сохранения файлов
        let fileManager = FileManager.default
        let targetDirectory = URL(fileURLWithPath: folder)
        let targetFileURL = targetDirectory.appendingPathComponent(fileName)
        
        do {
            try fileManager.createDirectory(at: targetDirectory, withIntermediateDirectories: true)
            
            // Сохраняем уменьшенную версию
            try resizedImage.pngData().unwrapOrThrow(ScreenshotSaveError.imageEncoding).write(to: targetFileURL, options: .atomic)
            
            // Если есть менеджер проекта, сохраняем сессионный скриншот
            // let projectManager = ProjectManager.shared
            // if let project = projectManager.currentProject {
            //     let sessionFile = projectManager.getSessionScreenshotFile(fileName)
            //     try saveBitmap(fullScreenImage, to: sessionFile)
            //     let projectFile = project.directory.appendingPathComponent(fileName)
            //     try saveBitmap(resizedImage, to: projectFile)
            // }
            
        } catch {
            print("[\(ScreenshotSaver.tag)] Could not save screenshot to file: \(error)")
            return false
        }
        
        return true
    }
    
    private func createImage(from pixels: [UInt32], width: Int, height: Int) -> UIImage? {
        guard width > 0, height > 0, pixels.count >= width * height else { return nil }
        var mutablePixels = pixels
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Big.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        guard let context = CGContext(data: &mutablePixels,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * MemoryLayout<UInt32>.size,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo),
              let image = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: image)
    }
}

private enum ScreenshotSaveError: Error { case imageEncoding }

private extension Optional where Wrapped == Data {
    func unwrapOrThrow(_ error: Error) throws -> Data {
        guard let value = self else { throw error }
        return value
    }
}

private extension UIImage {
    func scaledToFit(_ targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in self.draw(in: CGRect(origin: .zero, size: targetSize)) }
    }
}
