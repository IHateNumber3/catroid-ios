import Foundation

public final class SetLookEventId: EventId {
    public let sprite: Sprite?
    public let lookData: LookData?

    public init(sprite: Sprite?, look lookData: LookData?) {
        self.sprite = sprite
        self.lookData = lookData
        super.init()
    }

    public override func isEqual(to other: EventId) -> Bool {
        guard let that = other as? SetLookEventId, super.isEqual(to: other) else { return false }
        return sprite == that.sprite && lookData == that.lookData
    }

    public override var hashCode: Int {
        var result = super.hashCode
        result = result &* 31 &+ (sprite?.hashValue ?? 0)
        result = result &* 31 &+ (lookData?.hashValue ?? 0)
        return result
    }
}
