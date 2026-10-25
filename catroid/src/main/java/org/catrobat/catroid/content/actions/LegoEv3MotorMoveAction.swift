import Foundation

open class LegoEv3MotorMoveAction: TemporalAction {
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
        } ev3.0moveMotorSpeed(outputField, 0, speedValue);
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
