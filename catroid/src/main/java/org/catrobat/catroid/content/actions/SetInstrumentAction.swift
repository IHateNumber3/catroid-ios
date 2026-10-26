import Foundation

open class SetInstrumentAction: TemporalAction {
    var selectedInstrument: PickableMusicalInstrument!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        var instrument = MusicalInstrument.getInstrumentFromProgram(selectedInstrument.value)
        MidiSoundManager.instance.setInstrument(instrument)
    }

    public func setInstrument(_ selectedInstrument: PickableMusicalInstrument) {
        self.selectedInstrument = selectedInstrument
    }
}
