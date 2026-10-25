import Foundation

open class LegoEv3SetLedAction: TemporalAction {
    var ledStatusEnum: LedStatus!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var ev3 = btService.getDevice(BluetoothDevice.legoEv3)
        if ev3 == nil {
            return
        }
        var ledStatus: Int = 0x00
        // TODO(port): switch (ledStatusEnum) { case LED_OFF: ledStatus = 0x00;
        break
        case LED_GREEN: ledStatus = 0x01
        break
        case LED_RED: ledStatus = 0x02
        break
        case LED_ORANGE: ledStatus = 0x03
        break
        case LED_GREEN_FLASHING: ledStatus = 0x04
        break
        case LED_RED_FLASHING: ledStatus = 0x05
        break
        case LED_ORANGE_FLASHING: ledStatus = 0x06
        break
        case LED_GREEN_PULSE: ledStatus = 0x07
        break
        case LED_RED_PULSE: ledStatus = 0x08
        break
        case LED_ORANGE_PULSE: ledStatus = 0x09
        break
        } ev3.0setLed(ledStatus);
    }

    public func setLedStatusEnum(_ ledStatusEnum: LedStatus) {
        self.ledStatusEnum = ledStatusEnum
    }
}
