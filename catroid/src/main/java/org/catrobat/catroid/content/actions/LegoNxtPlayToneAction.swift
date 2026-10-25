import Foundation

open class LegoNxtPlayToneAction: TemporalAction {
    var hertz: Formula!
    var durationInSeconds: Formula!
    var scope: Scope!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var hertzInterpretation: Int
        var durationInterpretation: Float
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
        var nxt = btService.getDevice(BluetoothDevice.legoNxt)
        if nxt == nil {
            return
        }
        var durationInMs: Int = (int) (durationInterpretation * 1000)
        nxt.playTone(hertzInterpretation * 100, durationInMs)
    }

    public func setHertz(_ hertz: Formula) {
        self.hertz = hertz
    }

    public func setDurationInSeconds(_ durationInSeconds: Formula) {
        self.durationInSeconds = durationInSeconds
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
