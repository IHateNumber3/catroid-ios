import Foundation

open class LegoEv3MotorStopAction: TemporalAction {
    var motorEnum: Motor!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
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
        case ALL_MOTORS: outputField = (byte) 0x0F
        break
        } ev3.0stopMotor(outputField, 0, true);
    }

    public func setMotorEnum(_ motorEnum: Motor) {
        self.motorEnum = motorEnum
    }
}
