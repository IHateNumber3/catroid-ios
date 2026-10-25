import Foundation

open class PhiroMotorStopAction: TemporalAction {
    var motorEnum: Motor!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var phiro = btService.getDevice(BluetoothDevice.phiro)
        if phiro == nil {
            return
        }
        // TODO(port): switch (motorEnum) { case MOTOR_LEFT: phiro.stopLeftMotor();
        break
        case MOTOR_RIGHT: phiro.stopRightMotor()
        break
        case MOTOR_BOTH: phiro.stopAllMovements()
        break
        }
    }

    public func setMotorEnum(_ motorEnum: Motor) {
        self.motorEnum = motorEnum
    }
}
