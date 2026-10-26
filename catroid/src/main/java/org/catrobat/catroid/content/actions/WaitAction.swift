import Foundation

open class WaitAction: TemporalAction {
    var scope: Scope!
    var duration: Formula!

    public override init() { super.init() }

    open override func begin() {
        do {
            var newDuration: Float = try duration == nil ? Float(0) : duration.interpretFloat(scope)
            super.setDuration(newDuration)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setDelay(_ delay: Formula) {
        self.duration = delay
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    open override func update(_ percent: Float) {
    }
}
