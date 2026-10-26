import Foundation

public final class NfcEventId: EventId {
    let tag: String

    public init(uid tag: String) {
        self.tag = tag
        super.init()
    }

    public override func isEqual(to other: EventId) -> Bool {
        guard let that = other as? NfcEventId, super.isEqual(to: other) else { return false }
        return tag == that.tag
    }

    public override var hashCode: Int {
        var h = Hasher()
        h.combine(super.hashCode)
        h.combine(tag)
        return h.finalize()
    }
}
