import Foundation

/// Base for actions that dispatch an event to a set of receiving sprites.
open class EventAction: AsynchronousAction {
    open var receivingSprites: [Sprite] { [] }
    private var event: EventWrapper?
    public var wait = false

    open func getEventId() -> EventId? { nil }

    open override func initialize() {
        guard let id = getEventId() else {
            event = nil
            return
        }
        let wrapper = EventWrapper(eventId: id, waitForCompletion: wait)
        event = wrapper
        for sprite in receivingSprites {
            sprite.look.fire(wrapper)
        }
    }

    open override func isFinished() -> Bool {
        return event?.isWaitingForSprite() != true
    }
}
