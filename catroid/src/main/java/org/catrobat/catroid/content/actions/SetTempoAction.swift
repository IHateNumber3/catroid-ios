import Foundation

open class SetTempoAction: TemporalAction {
    var scope: Scope!
    var tempo: Formula!

    public override init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            var newTempo: Int = try tempo == nil ? Int(0) : tempo.interpretInteger(scope)
            MidiSoundManager.instance.setTempo(newTempo)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setTempo(_ tempo: Formula) {
        self.tempo = tempo
    }
}
