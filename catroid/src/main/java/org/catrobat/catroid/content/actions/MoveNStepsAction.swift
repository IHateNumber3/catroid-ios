import Foundation

open class MoveNStepsAction: TemporalAction {
    var scope: Scope!
    var steps: Formula!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        do {
            var stepsValue: Double = try steps == nil ? Double(0) : steps.interpretDouble(scope)
            var radians: Double = Double(scope.sprite.look.motionDirectionInUserInterfaceDimensionUnit) * Double.pi / 180.0
            scope.sprite.look.changePositionInInterfaceDimensionUnit(Float(stepsValue * sin(radians)), Float(stepsValue * cos(radians)))
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
