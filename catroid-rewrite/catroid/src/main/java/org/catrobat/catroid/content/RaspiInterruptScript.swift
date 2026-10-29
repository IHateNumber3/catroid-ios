import Foundation

public final class RaspiInterruptScript: Script {

    public var pin: String?
    public var eventValue: String?

    public convenience init(pin: String?, eventValue: String?) {
        self.init()
        self.pin = pin
        self.eventValue = eventValue
    }

    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil {
            cachedScriptBrick = WhenRaspiPinChangedBrick(script: self)
        }
        return cachedScriptBrick!
    }

    public override func createEventId(for sprite: Sprite) -> EventId? {
        return RaspiEventId(pin: pin, eventValue: eventValue)
    }

    public override func copyState(from other: Script) {
        super.copyState(from: other)
        if let o = other as? RaspiInterruptScript {
            pin = o.pin
            eventValue = o.eventValue
        }
    }
}
