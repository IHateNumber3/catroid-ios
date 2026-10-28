import Foundation
import AVFoundation

/// iOS sound playback manager. Regular audio assets are played through AVAudioPlayer;
/// MIDI assets remain routed through MidiSoundManager's MIDI-specific backend.
public final class SoundManager {
    public static let shared = SoundManager()
    public static func getInstance() -> SoundManager { shared }
    public var recentlyStoppedSoundfilePaths: Set<SoundFilePathWithSprite> = []
    public private(set) var mediaPlayers: [SoundPlaybackState] = []
    private var masterVolume: Float = 1
    public var volume: Float { masterVolume }

    public func setVolume(_ value: Float) {
        masterVolume = max(0, min(1, value))
        mediaPlayers.forEach { $0.audioPlayer?.volume = masterVolume }
    }

    public func playSoundFile(_ path: String, _ sprite: Sprite) {
        if let state = mediaPlayers.first(where: { $0.startedBySprite === sprite && $0.pathToSoundFile == path }) {
            if let player = state.audioPlayer {
                if !player.isPlaying { player.currentTime = 0; player.play() }
                state.isPlaying = player.isPlaying
                return
            }
        }
        guard FileManager.default.fileExists(atPath: path),
              let player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path)) else { return }
        player.volume = masterVolume
        player.prepareToPlay()
        let started = player.play()
        let state = SoundPlaybackState(isPlaying: started, startedBySprite: sprite,
                                       pathToSoundFile: path, currentPosition: 0)
        state.audioPlayer = player
        mediaPlayers.append(state)
    }

    public func playSoundFileWithStartTime(_ path: String, _ sprite: Sprite, _ offsetMilliseconds: Int) {
        playSoundFile(path, sprite)
        guard let state = mediaPlayers.first(where: { $0.startedBySprite === sprite && $0.pathToSoundFile == path }),
              let player = state.audioPlayer else { return }
        player.currentTime = max(0, Double(offsetMilliseconds) / 1000.0)
        if !player.isPlaying { player.play() }
        state.isPlaying = player.isPlaying
        state.currentPosition = Float(player.currentTime)
    }

    public func stopSoundFile(_ path: String, _ sprite: Sprite) {
        for state in mediaPlayers where state.startedBySprite === sprite && state.pathToSoundFile == path {
            state.audioPlayer?.stop()
            state.isPlaying = false
            state.currentPosition = 0
        }
    }

    public func stopAllSounds() {
        mediaPlayers.forEach { $0.audioPlayer?.stop(); $0.isPlaying = false; $0.currentPosition = 0 }
    }

    public func isSoundInSpritePlaying(_ sprite: Sprite, _ path: String) -> Bool {
        mediaPlayers.contains { $0.startedBySprite === sprite && $0.pathToSoundFile == path && ($0.audioPlayer?.isPlaying ?? $0.isPlaying) }
    }

    private init() {}
}

public final class SoundPlaybackState {
    public var isPlaying: Bool
    public weak var startedBySprite: Sprite?
    public var pathToSoundFile: String
    public var currentPosition: Float
    public var audioPlayer: AVAudioPlayer?
    public init(isPlaying: Bool = false, startedBySprite: Sprite? = nil, pathToSoundFile: String = "", currentPosition: Float = 0) {
        self.isPlaying = isPlaying
        self.startedBySprite = startedBySprite
        self.pathToSoundFile = pathToSoundFile
        self.currentPosition = currentPosition
        self.audioPlayer = nil
    }
}
