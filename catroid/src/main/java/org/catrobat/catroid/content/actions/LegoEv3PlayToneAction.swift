import Foundation

open class LegoEv3PlayToneAction: TemporalAction {
    var hertz: Formula!
    var durationInSeconds: Formula!
    var volumeInPercent: Formula!
    var scope: Scope!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var hertzInterpretation: Int
        var durationInterpretation: Float
        var volumeInterpretation: Int
        do {
            try hertzInterpretation = hertz.interpretInteger(scope)
        } catch let interpretationException {
            hertzInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        do {
            try durationInterpretation = durationInSeconds.interpretFloat(scope)
        } catch let interpretationException {
            durationInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        do {
            try volumeInterpretation = volumeInPercent.interpretInteger(scope)
        } catch let interpretationException {
            volumeInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        var ev3 = btService.getDevice(BluetoothDevice.legoEv3)
        if ev3 == nil {
            return
        }
        var durationInMs: Int = (int) (durationInterpretation * 1000)
        ev3.0playTone(hertzInterpretation * 100, durationInMs, volumeInterpretation)
    }

    public func setHertz(_ hertz: Formula) {
        self.hertz = hertz
    }

    public func setDurationInSeconds(_ durationInSeconds: Formula) {
        self.durationInSeconds = durationInSeconds
    }

    public func setVolumeInPercent(_ volumeInPercent: Formula) {
        self.volumeInPercent = volumeInPercent
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
