import Foundation

open class PlayDrumForBeatsAction: TemporalAction {
    var scope: Scope!
    var selectedDrum: PickableDrum!
    var beats: Formula!

    public required init() { super.init() }

    open override func begin() {
        do {
            var drum = Drum.getDrumFromProgram(selectedDrum.value)
            var playedBeats: Float = try beats == nil ? Float(0) : beats.interpretFloat(scope)
            MidiSoundManager.instance.playDrumForBeats(drum, playedBeats, scope.sprite)
            super.setDuration(Float(MidiSoundManager.instance).getDurationForBeats(playedBeats) / 1000)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setDrum(_ selectedDrum: PickableDrum) {
        self.selectedDrum = selectedDrum
    }

    public func setBeats(_ beats: Formula) {
        self.beats = beats
    }

    open override func update(_ percent: Float) {
    }
}
