import Foundation

open class TripleStitchAction: TemporalAction {
    var scope: Scope!
    var steps: Formula!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        var stepsInterpretation: Int = 0
        do {
            if steps != nil {
                stepsInterpretation = try steps.interpretInteger(scope)
            }
        } catch let interpretationException {
            stepsInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        self.scope.sprite.runningStitch.activateStitching(scope.sprite, TripleRunningStitch(sprite: scope.sprite, type: stepsInterpretation))
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setSteps(_ steps: Formula) {
        self.steps = steps
    }
}
