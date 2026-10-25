import Foundation

open class PointInDirectionAction: TemporalAction {
    var scope: Scope!
    var degrees: Formula!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        do {
            var degreeInterpretation: Float = try degrees == nil ? Float(0) : degrees.interpretFloat(scope)
            if scope.sprite.look is PhysicsLook {
                (scope.sprite.look as! PhysicsLook).setFlippedByDirection(degreeInterpretation)
            }
            scope.sprite.look.setMotionDirectionInUserInterfaceDimensionUnit(degreeInterpretation)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setDegreesInUserInterfaceDimensionUnit(_ degrees: Formula) {
        self.degrees = degrees
    }
}
