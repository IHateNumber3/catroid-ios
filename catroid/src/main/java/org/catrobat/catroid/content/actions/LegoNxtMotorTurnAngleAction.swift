import Foundation

open class LegoNxtMotorTurnAngleAction: TemporalAction {
    var motorEnum: Motor!
    var degrees: Formula!
    var scope: Scope!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var degreesValue: Int
        do {
            try degreesValue = degrees.interpretInteger(scope)
        } catch let interpretationException {
            degreesValue = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        var tmpAngle: Int = degreesValue
        var direction: Int = 1
        if degreesValue < 0 {
            direction = -1
            tmpAngle = degreesValue + (-2 * degreesValue)
        }
        var nxt = btService.getDevice(BluetoothDevice.legoNxt)
        if nxt == nil {
            return
        }
        // TODO(port): switch (motorEnum) { case MOTOR_A: nxt.getMotorA().move(direction * 30, tmpAngle);
        break
        case MOTOR_B: nxt.motorB.move(direction * 30, tmpAngle)
        break
        case MOTOR_C: nxt.motorC.move(direction * 30, tmpAngle)
        break
        case MOTOR_B_C: nxt.motorB.move(direction * 30, tmpAngle)
        nxt.motorC.move(direction * 30, tmpAngle)
        break
        }
    }

    public func setMotorEnum(_ motorEnum: Motor) {
        self.motorEnum = motorEnum
    }

    public func setDegrees(_ degrees: Formula) {
        self.degrees = degrees
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
