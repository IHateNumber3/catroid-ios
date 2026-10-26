import Foundation
import AVFoundation

/// Минимальная замена MidiSoundManager: тембр выбирается через AVAudioUnitSampler (нужен SoundFont/DLS).
/// Воспроизведение нот будет подключено вместе с PlayNoteBrick.
public final class MidiSoundManager {
    public static let shared = MidiSoundManager()
    public static var instance: MidiSoundManager { return shared }
    public static func getInstance() -> MidiSoundManager { return shared }

    public private(set) var instrument: MusicalInstrument = .acousticGrandPiano

    public func setInstrument(_ instrument: MusicalInstrument) {
        self.instrument = instrument
    }
}
