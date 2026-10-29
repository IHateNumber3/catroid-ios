import Foundation

public final class CollidingSprites: Hashable {
    public let sprite1: Sprite
    public let sprite2: Sprite

    public init(_ sprite1: Sprite, _ sprite2: Sprite) {
        self.sprite1 = sprite1
        self.sprite2 = sprite2
    }

    /// Симметричное равенство (порядок спрайтов не важен)
    public static func == (l: CollidingSprites, r: CollidingSprites) -> Bool {
        return l === r
            || (l.sprite1 == r.sprite1 && l.sprite2 == r.sprite2)
            || (l.sprite2 == r.sprite1 && l.sprite1 == r.sprite2)
    }

    public func hash(into hasher: inout Hasher) {
        // сумма — симметрична, как Objects.hash(a)+Objects.hash(b)
        hasher.combine(sprite1.hashValue &+ sprite2.hashValue)
    }
}
