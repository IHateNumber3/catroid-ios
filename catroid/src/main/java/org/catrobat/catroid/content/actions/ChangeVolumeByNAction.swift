import Foundation

open class ChangeVolumeByNAction: TemporalAction {
    var volume: Formula!
    var scope: Scope!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        do {
            var newVolume: Float = try volume == nil ? Float(0) : volume.interpretFloat(scope)
            SoundManager.getInstance().setVolume(SoundManager.getInstance().volume + newVolume)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setVolume(_ volume: Formula) {
        self.volume = volume
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
