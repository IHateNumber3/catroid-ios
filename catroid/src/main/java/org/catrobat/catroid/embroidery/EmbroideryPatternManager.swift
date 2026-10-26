import Foundation
import UIKit

public protocol StitchCommand {}

/// Заглушка DSTStitchCommand; полноценная вышивка — отдельный порт
public struct DSTStitchCommand: StitchCommand {
    public init(_ x: Float, _ y: Float, _ layer: Int, _ sprite: Sprite, _ color: UIColor) {}
}

public final class EmbroideryPatternManager {
    private var commands: [StitchCommand] = []
    public init() {}
    public func addStitchCommand(_ c: StitchCommand) { commands.append(c) }
}
