import Foundation

/// Waits for the selected sound to stop. Playback tracking is supplied by the iOS sound managers.
open class WaitForSoundAction: WaitAction {
    public static let TAG = String(describing: WaitForSoundAction.self)
    private var soundFilePath: String?
    private var soundManager: SoundManager = .shared
    private var midiSoundManager: MidiSoundManager = .shared
    private var soundStopped = false

    public required init() { super.init() }

    public func setSoundFilePath(_ path: String) { soundFilePath = path }

    open override func update(_ percent: Float) {
        guard let path = soundFilePath, let sprite = scope?.sprite else { return }
        let key = SoundFilePathWithSprite(soundFilePath: path, sprite: sprite)
        if midiSoundManager.startedSoundfilePaths.contains(key),
           !midiSoundManager.isSoundInSpritePlaying(sprite, path) {
            midiSoundManager.startedSoundfilePaths.remove(key)
            soundStopped = true
            finish()
            return
        }
        if soundManager.recentlyStoppedSoundfilePaths.contains(key) {
            soundManager.recentlyStoppedSoundfilePaths.remove(key)
            soundStopped = true
            finish()
        }
    }

    open override func end() {
        guard let path = soundFilePath, let sprite = scope?.sprite, !soundStopped else { return }
        if let player = soundManager.mediaPlayers.first(where: { $0.isPlaying && $0.startedBySprite === sprite && $0.pathToSoundFile == path }) {
            restart(); setTime(player.currentPosition)
        } else if let player = midiSoundManager.midiPlayers.first(where: { $0.isPlaying && $0.startedBySprite === sprite && $0.pathToSoundFile == path }) {
            restart(); setTime(player.currentPosition)
        }
    }

    public func setSoundManager(_ soundManager: SoundManager) { self.soundManager = soundManager }
    public func setMidiSoundManager(_ soundManager: MidiSoundManager) { self.midiSoundManager = soundManager }
}
