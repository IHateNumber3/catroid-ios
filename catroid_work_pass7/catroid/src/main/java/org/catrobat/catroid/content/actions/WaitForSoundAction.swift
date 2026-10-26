import Foundation

open class WaitForSoundAction: WaitAction {
    public static let TAG: String = String(describing: WaitForSoundAction.self)
    var soundFilePath: String!
    var soundManager: SoundManager = SoundManager.instance
    var midiSoundManager: MidiSoundManager = MidiSoundManager.instance
    var soundStopped: Bool = false

    public required init() { super.init() }

    public func setSoundFilePath(_ soundFilePath: String) {
        self.soundFilePath = soundFilePath
    }

    open override func update(_ percent: Float) {
        if soundFilePath != nil && !midiSoundManager.startedSoundfilePaths.isEmpty() {
            let spriteSoundFilePath = SoundFilePathWithSprite(soundFilePath, scope.sprite)
            var recentlyStarted = midiSoundManager.startedSoundfilePaths
            if recentlyStarted.contains(spriteSoundFilePath) && !midiSoundManager.isSoundInSpritePlaying(scope.sprite, soundFilePath) {
                recentlyStarted.remove(spriteSoundFilePath)
                finish()
                soundStopped = true
                return
            }
        }
        if soundFilePath != nil && !soundManager.recentlyStoppedSoundfilePaths.isEmpty() {
            let spriteSoundFilePath = SoundFilePathWithSprite(soundFilePath, scope.sprite)
            var recentlyStopped = soundManager.recentlyStoppedSoundfilePaths
            if recentlyStopped.contains(spriteSoundFilePath) {
                recentlyStopped.remove(spriteSoundFilePath)
                finish()
                soundStopped = true
            }
        }
    }

    open override func end() {
        for mediaPlayer in soundManager.mediaPlayers {
            if mediaPlayer.isPlaying() && mediaPlayer.startedBySprite == scope.sprite && mediaPlayer.pathToSoundFile.equals(soundFilePath) && !soundStopped {
                restart()
                setTime(mediaPlayer.currentPosition)
            }
        }
        for midiPlayer in midiSoundManager.midiPlayers {
            if midiPlayer.isPlaying() && midiPlayer.startedBySprite == scope.sprite && midiPlayer.pathToSoundFile.equals(soundFilePath) && !soundStopped {
                restart()
                setTime(midiPlayer.currentPosition)
            }
        }
    }

    public func setSoundManager(_ soundManager: SoundManager) {
        self.soundManager = soundManager
    }

    public func setMidiSoundManager(_ midiSoundManager: MidiSoundManager) {
        self.midiSoundManager = midiSoundManager
    }
}
