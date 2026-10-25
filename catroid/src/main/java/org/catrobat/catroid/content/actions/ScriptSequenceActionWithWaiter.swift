import Foundation

public final class ScriptSequenceActionWithWaiter: ScriptSequenceAction {

    private let waiterEvent: EventWrapper
    private let waiterSprite: Sprite

    init(thread: ScriptSequenceAction, event: EventWrapper, sprite: Sprite) {
        self.waiterEvent = event
        self.waiterSprite = sprite
        super.init(script: thread.script)
        thread.getActions().forEach { addAction($0) }
    }

    public func notifyWaiter() {
        waiterEvent.notify(sprite: waiterSprite)
    }
}
