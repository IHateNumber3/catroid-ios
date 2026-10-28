import Foundation

open class RunningStitchAction: TemporalAction {
    var scope: Scope!
    var length: Formula!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        var lengthInterpretation: Int = 0
        do {
            if length != nil {
                try lengthInterpretation = length.interpretInteger(scope)
            }
        } catch let interpretationException {
            lengthInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        self.scope.sprite.runningStitch.activateStitching(sprite: scope.sprite, type: SimpleRunningStitch(scope.sprite, lengthInterpretation))
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setLength(_ length: Formula) {
        self.length = length
    }
}
