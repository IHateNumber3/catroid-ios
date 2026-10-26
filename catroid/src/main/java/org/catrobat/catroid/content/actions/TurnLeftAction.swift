import Foundation

open class TurnLeftAction: TemporalAction {
    var scope: Scope!
    var degrees: Formula!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        do {
            var newDegrees: Float = try degrees == nil ? Float(0) : -degrees.interpretFloat(scope)
            if scope.sprite.look is PhysicsLook {
                (scope.sprite.look as! PhysicsLook).setFlippedByDegree(newDegrees)
            }
            scope.sprite.look.changeDirectionInUserInterfaceDimensionUnit(newDegrees)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setDegrees(_ degrees: Formula) {
        self.degrees = degrees
    }
}
