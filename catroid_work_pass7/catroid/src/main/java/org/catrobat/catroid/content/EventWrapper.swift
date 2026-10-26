import Foundation

public final class EventWrapper: Event {

    let eventId: EventId
    private let wait: Bool
    private var spriteWaitList: [Sprite: Int] = [:]

    public init(eventId: EventId, waitForCompletion wait: Bool) {
        self.eventId = eventId
        self.wait = wait
        super.init()
    }

    public func notify(sprite: Sprite) {
        guard let count = spriteWaitList[sprite] else { return }
        let next = count - 1
        if next == 0 {
            spriteWaitList.removeValue(forKey: sprite)
        } else {
            spriteWaitList[sprite] = next
        }
    }

    @discardableResult
    func addSpriteToWaitList(_ sprite: Sprite) -> Bool {
        if wait {
            spriteWaitList[sprite, default: 0] += 1
        }
        return wait
    }

    public func isWaitingForSprite() -> Bool {
        return !spriteWaitList.isEmpty
    }
}
