import Foundation

open class SetVolumeToAction: TemporalAction {
    var volume: Formula!
    var scope: Scope!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        do {
            var newVolume: Float = try volume == nil ? Float(0) : volume.interpretFloat(scope)
            SoundManager.shared.setVolume(newVolume)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setVolume(_ volume: Formula) {
        self.volume = volume
    }
}
