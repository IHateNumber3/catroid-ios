import Foundation

open class PhiroMotorMoveForwardAction: TemporalAction {
    public static let MIN_SPEED: Int = 0
    public static let MAX_SPEED: Int = 100
    var motorEnum: Any!
    var speed: Formula!
    var scope: Scope!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    public func setMotorEnum(_ motorEnum: Any) {
        self.motorEnum = motorEnum
    }

    public func setSpeed(_ speed: Formula) {
        self.speed = speed
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
