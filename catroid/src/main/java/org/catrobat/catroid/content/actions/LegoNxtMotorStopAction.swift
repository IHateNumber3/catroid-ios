import Foundation

open class LegoNxtMotorStopAction: TemporalAction {
    var motorEnum: Any!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    public func setMotorEnum(_ motorEnum: Any) {
        self.motorEnum = motorEnum
    }
}
