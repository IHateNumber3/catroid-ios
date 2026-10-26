import Foundation

open class LegoEv3SetLedAction: TemporalAction {
    var ledStatusEnum: Any!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    public func setLedStatusEnum(_ ledStatusEnum: Any) {
        self.ledStatusEnum = ledStatusEnum
    }
}
