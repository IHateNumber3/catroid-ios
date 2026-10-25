import Foundation

open class PhiroMotorMoveBackwardAction: TemporalAction {
    public static let MIN_SPEED: Int = 0
    public static let MAX_SPEED: Int = 100
    var motorEnum: Motor!
    var speed: Formula!
    var scope: Scope!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var speedValue: Int
        do {
            try speedValue = speed.interpretInteger(scope)
        } catch let interpretationException {
            speedValue = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        if speedValue < MIN_SPEED {
            speedValue = MIN_SPEED
        } else if speedValue > MAX_SPEED {
            speedValue = MAX_SPEED
        }
        var phiro = btService.getDevice(BluetoothDevice.phiro)
        if phiro == nil {
            return
        }
        // TODO(port): switch (motorEnum) { case MOTOR_LEFT: phiro.moveLeftMotorBackward(speedValue);
        break
        case MOTOR_RIGHT: phiro.moveRightMotorBackward(speedValue)
        break
        case MOTOR_BOTH: phiro.moveRightMotorBackward(speedValue)
        phiro.moveLeftMotorBackward(speedValue)
        break
        }
    }

    public func setMotorEnum(_ motorEnum: Motor) {
        self.motorEnum = motorEnum
    }

    public func setSpeed(_ speed: Formula) {
        self.speed = speed
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
