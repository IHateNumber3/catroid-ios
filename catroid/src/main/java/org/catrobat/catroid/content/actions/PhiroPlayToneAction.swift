import Foundation

open class PhiroPlayToneAction: TemporalAction {
    var toneEnum: Tone!
    var durationInSeconds: Formula!
    var scope: Scope!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var durationInterpretation: Int
        do {
            try durationInterpretation = durationInSeconds.interpretInteger(scope)
        } catch let interpretationException {
            durationInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        var phiro = btService.getDevice(BluetoothDevice.phiro)
        if phiro == nil {
            return
        }
        // TODO(port): switch (toneEnum) { case DO: phiro.playTone(262, durationInterpretation);
        break
        case RE: phiro.playTone(294, durationInterpretation)
        break
        case MI: phiro.playTone(330, durationInterpretation)
        break
        case FA: phiro.playTone(349, durationInterpretation)
        break
        case SO: phiro.playTone(392, durationInterpretation)
        break
        case LA: phiro.playTone(440, durationInterpretation)
        break
        case TI: phiro.playTone(494, durationInterpretation)
        break
        }
    }

    public func setSelectedTone(_ toneEnum: Tone) {
        self.toneEnum = toneEnum
    }

    public func setDurationInSeconds(_ durationInSeconds: Formula) {
        self.durationInSeconds = durationInSeconds
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
