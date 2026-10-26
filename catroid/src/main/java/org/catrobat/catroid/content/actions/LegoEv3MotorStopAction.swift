import Foundation

open class LegoEv3MotorStopAction: TemporalAction {
    var motorEnum: Any!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    public func setMotorEnum(_ motorEnum: Any) {
        self.motorEnum = motorEnum
    }
}
