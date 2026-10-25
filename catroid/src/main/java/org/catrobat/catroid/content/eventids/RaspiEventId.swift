import Foundation

public final class RaspiEventId: EventId {
    private let pin: String?
    private let eventValue: String?

    public init(pin: String?, eventValue: String?) {
        self.pin = pin
        self.eventValue = eventValue
        super.init()
    }

    public override func isEqual(to other: EventId) -> Bool {
        guard let that = other as? RaspiEventId, super.isEqual(to: other) else { return false }
        return pin == that.pin && eventValue == that.eventValue
    }

    public override var hashCode: Int {
        var result = pin?.hashValue ?? 0
        result = result &* 31 &+ (eventValue?.hashValue ?? 0)
        return result
    }
}
