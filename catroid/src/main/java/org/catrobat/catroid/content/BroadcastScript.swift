import Foundation

public final class BroadcastScript: Script {

    private var receivedMessage: String?

    public convenience init(receivedMessage: String?) {
        self.init()
        self.receivedMessage = receivedMessage
    }

    public var broadcastMessage: String? {
        get { return receivedMessage }
        set { receivedMessage = newValue }
    }

    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil {
            cachedScriptBrick = BroadcastReceiverBrick(script: self)
        }
        return cachedScriptBrick!
    }

    public override func createEventId(for sprite: Sprite) -> EventId? {
        return BroadcastEventId(message: receivedMessage)
    }

    public override func copyState(from other: Script) {
        super.copyState(from: other)
        if let o = other as? BroadcastScript {
            receivedMessage = o.receivedMessage
        }
    }
}
