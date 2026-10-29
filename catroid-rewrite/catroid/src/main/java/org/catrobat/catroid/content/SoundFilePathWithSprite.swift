import Foundation

public struct SoundFilePathWithSprite: Hashable {
    public let soundFilePath: String
    public let sprite: Sprite
    public init(soundFilePath: String, sprite: Sprite) { self.soundFilePath = soundFilePath; self.sprite = sprite }
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.soundFilePath == rhs.soundFilePath && lhs.sprite === rhs.sprite }
    public func hash(into hasher: inout Hasher) { hasher.combine(soundFilePath); hasher.combine(ObjectIdentifier(sprite)) }
}
