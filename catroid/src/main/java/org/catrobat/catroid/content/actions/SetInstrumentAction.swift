import Foundation

open class SetInstrumentAction: TemporalAction {
    var selectedInstrument: PickableMusicalInstrument!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        let instrument = MusicalInstrument.getInstrumentFromProgram(selectedInstrument.value)
        MidiSoundManager.shared.setInstrument(instrument)
    }

    public func setInstrument(_ selectedInstrument: PickableMusicalInstrument) {
        self.selectedInstrument = selectedInstrument
    }
}
