import Foundation

open class PlayNoteForBeatsAction: TemporalAction {
    var scope: Scope!
    var midiValue: Formula!
    var beats: Formula!

    public required init() { super.init() }

    open override func begin() {
        do {
            var playedMidiValue: Int = 0
            if midiValue != nil {
                try playedMidiValue = midiValue.interpretInteger(scope)
            }
            var playedBeats: Float = 0
            if beats != nil {
                try playedBeats = beats.interpretFloat(scope)
            }
            MidiSoundManager.instance.playNoteForBeats(playedMidiValue, playedBeats)
            super.setDuration(Float(MidiSoundManager.instance).getDurationForBeats(playedBeats) / 1000)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setMidiValue(_ midiValue: Formula) {
        self.midiValue = midiValue
    }

    public func setBeats(_ beats: Formula) {
        self.beats = beats
    }

    open override func update(_ percent: Float) {
    }
}
