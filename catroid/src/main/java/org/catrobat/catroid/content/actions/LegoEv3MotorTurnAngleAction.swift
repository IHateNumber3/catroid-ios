import Foundation

open class LegoEv3MotorTurnAngleAction: TemporalAction {
    public static let MAX_SPEED: Int = 100
    public static let POWER_DOWN_RAMP_DEGREES: Int = 20
    var motorEnum: Any!
    var degrees: Formula!
    var scope: Scope!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    public func setMotorEnum(_ motorEnum: LegoEv3MotorTurnAngleBrick.Motor) {
        self.motorEnum = motorEnum
    }

    public func setDegrees(_ degrees: Formula) {
        self.degrees = degrees
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
