import Foundation

open class PhiroPlayToneAction: TemporalAction {
    var toneEnum: Any!
    var durationInSeconds: Formula!
    var scope: Scope!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    public func setSelectedTone(_ toneEnum: Any) {
        self.toneEnum = toneEnum
    }

    public func setDurationInSeconds(_ durationInSeconds: Formula) {
        self.durationInSeconds = durationInSeconds
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
