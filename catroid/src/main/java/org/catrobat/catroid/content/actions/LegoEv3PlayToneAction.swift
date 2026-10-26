import Foundation

open class LegoEv3PlayToneAction: TemporalAction {
    var hertz: Formula!
    var durationInSeconds: Formula!
    var volumeInPercent: Formula!
    var scope: Scope!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
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
