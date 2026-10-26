import Foundation

open class StopAllSoundsAction: TemporalAction {
    public override init() { super.init() }

    open override func update(_ percent: Float) {
        SoundManager.instance.stopAllSounds()
        MidiSoundManager.instance.stopAllSounds()
    }
}
