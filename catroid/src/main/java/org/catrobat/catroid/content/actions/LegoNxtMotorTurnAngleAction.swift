import Foundation

open class LegoNxtMotorTurnAngleAction: TemporalAction {
    var motorEnum: Any!
    var degrees: Formula!
    var scope: Scope!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    public func setMotorEnum(_ motorEnum: Any) {
        self.motorEnum = motorEnum
    }

    public func setDegrees(_ degrees: Formula) {
        self.degrees = degrees
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
