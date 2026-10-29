import Foundation

public final class BounceOffEventId: EventId {
    public let bouncingSprite: Sprite?
    public let staticSprite: Sprite?

    public init(sprite bouncingSprite: Sprite?, spriteToBounceOff staticSprite: Sprite?) {
        self.bouncingSprite = bouncingSprite
        self.staticSprite = staticSprite
        super.init()
    }

    public override func isEqual(to other: EventId) -> Bool {
        guard let that = other as? BounceOffEventId, super.isEqual(to: other) else { return false }
        return bouncingSprite == that.bouncingSprite && staticSprite == that.staticSprite
    }

    public override var hashCode: Int {
        var h = Hasher()
        h.combine(super.hashCode)
        h.combine(bouncingSprite)
        h.combine(staticSprite)
        return h.finalize()
    }
}
