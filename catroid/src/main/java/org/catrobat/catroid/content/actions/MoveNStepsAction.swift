import Foundation

open class MoveNStepsAction: TemporalAction {
    var scope: Scope!
    var steps: Formula!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        do {
            var stepsValue: Double = try steps == nil ? Double(0) : steps.interpretDouble(scope)
            var radians: Double = Math.toRadians(scope.sprite.look.motionDirectionInUserInterfaceDimensionUnit)
            scope.sprite.look.changePositionInInterfaceDimensionUnit((float) (stepsValue * Math.sin(radians)), (float) (stepsValue * Math.cos(radians)))
            scope.sprite.movedByStepsBrick = true
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setSteps(_ steps: Formula) {
        self.steps = steps
    }
}
