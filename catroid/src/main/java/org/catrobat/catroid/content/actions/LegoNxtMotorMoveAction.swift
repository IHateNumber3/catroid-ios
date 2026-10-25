import Foundation

open class LegoNxtMotorMoveAction: TemporalAction {
    public static let MIN_SPEED: Int = -100
    public static let MAX_SPEED: Int = 100
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)
    var motorEnum: Motor!
    var speed: Formula!
    var scope: Scope!

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
        var nxt = btService.getDevice(BluetoothDevice.legoNxt)
        if nxt == nil {
            return
        }
        // TODO(port): switch (motorEnum) { case MOTOR_A: nxt.getMotorA().move(speedValue);
        break
        case MOTOR_B: nxt.motorB.move(speedValue)
        break
        case MOTOR_C: nxt.motorC.move(speedValue)
        break
        case MOTOR_B_C: nxt.motorB.move(speedValue)
        nxt.motorC.move(speedValue)
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
