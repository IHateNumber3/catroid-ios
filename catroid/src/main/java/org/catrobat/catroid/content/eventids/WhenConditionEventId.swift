import Foundation

public final class WhenConditionEventId: EventId {
    let formula: Formula?

    public init(formula: Formula?) {
        self.formula = formula
        super.init()
    }

    public override func isEqual(to other: EventId) -> Bool {
        guard let that = other as? WhenConditionEventId, super.isEqual(to: other) else { return false }
        return formula == that.formula
    }

    public override var hashCode: Int {
        var result = super.hashCode
        result = result &* 31 &+ (formula?.hashValue ?? 0)
        return result
    }
}
