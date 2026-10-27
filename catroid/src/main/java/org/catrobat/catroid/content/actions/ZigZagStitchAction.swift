import Foundation

open class ZigZagStitchAction: TemporalAction {
    var scope: Scope!
    var length: Formula!
    var width: Formula!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        var lengthInterpretation: Float = 0
        var heightInterpretation: Float = 0
        do {
            if length != nil {
                try lengthInterpretation = length.interpretFloat(scope)
            }
        } catch let interpretationException {
            lengthInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        do {
            if width != nil {
                try heightInterpretation = width.interpretFloat(scope)
            }
        } catch let interpretationException {
            heightInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        self.scope.sprite.runningStitch.activateStitching(sprite: scope.sprite, type: ZigZagRunningStitch(scope.sprite, lengthInterpretation, heightInterpretation))
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setLength(_ length: Formula) {
        self.length = length
    }

    public func setWidth(_ width: Formula) {
        self.width = width
    }
}
