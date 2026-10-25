import Foundation

open class LegoEv3MotorTurnAngleAction: TemporalAction {
    public static let MAX_SPEED: Int = 100
    public static let POWER_DOWN_RAMP_DEGREES: Int = 20
    var motorEnum: LegoEv3MotorTurnAngleBrick.Motor!
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
        var step2Angle: Int = 0
        var step3Angle: Int = 0
        if tmpAngle > POWER_DOWN_RAMP_DEGREES {
            step2Angle = tmpAngle - POWER_DOWN_RAMP_DEGREES
            step3Angle = POWER_DOWN_RAMP_DEGREES
        } else {
            step2Angle = tmpAngle
        }
        var ev3 = btService.getDevice(BluetoothDevice.legoEv3)
        if ev3 == nil {
            return
        }
        var outputField = (byte) 0x00
        // TODO(port): switch (motorEnum) { case MOTOR_A: outputField = (byte) 0x01;
        break
        case MOTOR_B: outputField = (byte) 0x02
        break
        case MOTOR_C: outputField = (byte) 0x04
        break
        case MOTOR_D: outputField = (byte) 0x08
        break
        case MOTOR_B_C: outputField = (byte) 0x06
        break
        } ev3.0moveMotorStepsSpeed(outputField, 0, direction * MAX_SPEED, 0, step2Angle, step3Angle, true);
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
