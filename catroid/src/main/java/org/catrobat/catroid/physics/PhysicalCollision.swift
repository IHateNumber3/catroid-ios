import Foundation

public final class PhysicalCollision: Hashable, CustomStringConvertible {
    private(set) var contactCounter = 0
    private let objects: CollidingSprites

    init(_ objects: CollidingSprites) { self.objects = objects }

    func increaseContactCounter() { contactCounter += 1 }
    func decreaseContactCounter() { if contactCounter > 0 { contactCounter -= 1 } }

    func sendBounceOffEvents() {
        sendBounceOffEvent(objects.sprite1, objects.sprite2)
        sendBounceOffEvent(objects.sprite2, objects.sprite1)
    }

    private func sendBounceOffEvent(_ spriteBouncingOff: Sprite, _ otherSprite: Sprite) {
        if spriteBouncingOff.isClone {
            PhysicalCollision.fireBounceOffEvent(spriteBouncingOff.myOriginal, otherSprite)
        }
        if otherSprite.isClone {
            PhysicalCollision.fireBounceOffEvent(spriteBouncingOff, otherSprite.myOriginal)
        }
        PhysicalCollision.fireBounceOffEvent(spriteBouncingOff, otherSprite)
        PhysicalCollision.fireBounceOffEvent(spriteBouncingOff, nil)
    }

    public static func fireBounceOffEvent(_ bouncingSprite: Sprite?, _ staticSprite: Sprite?) {
        let identifier = BounceOffEventId(sprite: bouncingSprite, spriteToBounceOff: staticSprite)
        let event = EventWrapper(eventId: identifier, waitForCompletion: false)
        ProjectManager.shared.currentProject?.fireToAllSprites(event)
    }

    public var description: String {
        return "PhysicalCollision:\n sprite1: \(objects.sprite1)\n sprite2: \(objects.sprite2)\n contactCounter: \(contactCounter)\n"
    }

    public static func == (l: PhysicalCollision, r: PhysicalCollision) -> Bool {
        return l === r || l.objects == r.objects
    }
    public func hash(into hasher: inout Hasher) { hasher.combine(objects) }
}
