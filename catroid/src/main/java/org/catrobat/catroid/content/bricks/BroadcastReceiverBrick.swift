import Foundation

/// Script header for a broadcast receiver, paired with BroadcastScript.
open class BroadcastReceiverBrick: ScriptBrickBaseType {
    public required init() {
        super.init(script: BroadcastScript(receivedMessage: nil), ownsScript: true)
    }

    public override init(script: Script, ownsScript: Bool = false) {
        super.init(script: script, ownsScript: ownsScript)
    }

    public var broadcastMessage: String? {
        get { (script as? BroadcastScript)?.broadcastMessage }
        set { (script as? BroadcastScript)?.broadcastMessage = newValue }
    }
}
