import Foundation

open class LegoNxtMotorStopAction: TemporalAction {
    var motorEnum: Motor!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var nxt = btService.getDevice(BluetoothDevice.legoNxt)
        if nxt == nil {
            return
        }
        // TODO(port): switch (motorEnum) { case MOTOR_A: nxt.getMotorA().stop();
        break
        case MOTOR_B: nxt.motorB.stop()
        break
        case MOTOR_C: nxt.motorC.stop()
        break
        case MOTOR_B_C: nxt.motorB.stop()
        nxt.motorC.stop()
        break
        case ALL_MOTORS: nxt.stopAllMovements()
        break
        }
    }

    public func setMotorEnum(_ motorEnum: Motor) {
        self.motorEnum = motorEnum
    }
}
