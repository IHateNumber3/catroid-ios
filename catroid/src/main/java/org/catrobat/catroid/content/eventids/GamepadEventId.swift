import Foundation

public final class GamepadEventId: EventId {
    let buttonPressed: String?

    public init(action buttonPressed: String?) {
        self.buttonPressed = buttonPressed
        super.init()
    }

    public override func isEqual(to other: EventId) -> Bool {
        guard let that = other as? GamepadEventId, super.isEqual(to: other) else { return false }
        return buttonPressed == that.buttonPressed
    }

    public override var hashCode: Int {
        var h = Hasher()
        h.combine(super.hashCode)
        h.combine(buttonPressed)
        return h.finalize()
    }
}
