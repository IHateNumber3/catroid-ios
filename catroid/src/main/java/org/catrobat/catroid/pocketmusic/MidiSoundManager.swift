import Foundation
import AVFoundation

/// Минимальная замена MidiSoundManager: тембр выбирается через AVAudioUnitSampler (нужен SoundFont/DLS).
/// Воспроизведение нот будет подключено вместе с PlayNoteBrick.
public final class MidiSoundManager {
    public static let shared = MidiSoundManager()
    public static func getInstance() -> MidiSoundManager { return shared }

    public private(set) var instrument: MusicalInstrument = .acousticGrandPiano
    public private(set) var tempo: Float = 60
    public func setTempo(_ value: Float) { tempo = max(1, value) }
    public func setVolume(_ value: Float) { }
    public func playSoundFile(_ path: String, _ sprite: Sprite) {
        if let player = midiPlayers.first(where: { $0.startedBySprite === sprite && $0.pathToSoundFile == path }) {
            player.isPlaying = true
        } else {
            midiPlayers.append(SoundPlaybackState(isPlaying: true, startedBySprite: sprite, pathToSoundFile: path))
        }
    }
    public func stopSoundFile(_ path: String, _ sprite: Sprite) {
        for player in midiPlayers where player.startedBySprite === sprite && player.pathToSoundFile == path { player.isPlaying = false }
    }
    public func stopAllSounds() { midiPlayers.forEach { $0.isPlaying = false } }
    public var startedSoundfilePaths: Set<SoundFilePathWithSprite> = []
    public var midiPlayers: [SoundPlaybackState] = []

    public func isSoundInSpritePlaying(_ sprite: Sprite, _ path: String) -> Bool {
        return midiPlayers.contains { $0.isPlaying && $0.startedBySprite === sprite && $0.pathToSoundFile == path }
    }

    public func setInstrument(_ instrument: MusicalInstrument) {
        self.instrument = instrument
    }
}
