import Foundation

open class PhiroMotorStopAction: TemporalAction {
    var motorEnum: Any!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    public func setMotorEnum(_ motorEnum: Any) {
        self.motorEnum = motorEnum
    }
}
