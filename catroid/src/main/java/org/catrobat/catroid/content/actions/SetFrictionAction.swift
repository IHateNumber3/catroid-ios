import Foundation

open class SetFrictionAction: TemporalAction {
    var scope: Scope!
    var physicsObject: PhysicsObject!
    var friction: Formula!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        do {
            var newFriction: Float = try friction == nil ? Float(0) : friction.interpretFloat(scope)
            physicsObject.setFriction(newFriction / 100.0)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setPhysicsObject(_ physicsObject: PhysicsObject) {
        self.physicsObject = physicsObject
    }

    public func setFriction(_ friction: Formula) {
        self.friction = friction
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
