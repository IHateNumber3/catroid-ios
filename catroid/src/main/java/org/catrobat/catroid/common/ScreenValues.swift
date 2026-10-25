import Foundation
import UIKit

public enum ScreenValues {
    private static let defaultScreenResolution = Resolution(1280, 768)
    public static let castScreenResolution = Resolution(1280, 720)
    public static var currentScreenResolution: Resolution?

    public static func setToDefaultScreenSize() {
        currentScreenResolution = defaultScreenResolution
    }

    public static func getResolution(for project: Project) -> Resolution? {
        return project.isCastProject ? castScreenResolution : currentScreenResolution
    }

    /// ScreenValueHandler.updateScreenWidthAndHeight(context)
    public static func updateScreenWidthAndHeight() {
        let b = UIScreen.main.nativeBounds
        currentScreenResolution = Resolution(Int(b.width), Int(b.height))
    }
}
