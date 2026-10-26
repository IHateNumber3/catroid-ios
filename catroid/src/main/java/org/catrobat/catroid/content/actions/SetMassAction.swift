import Foundation

open class SetMassAction: TemporalAction {
    var scope: Scope!
    var physicsObject: PhysicsObject!
    var mass: Formula!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        var newMass: Float
        do {
            try newMass = mass == nil ? Float(0) : mass.interpretFloat(scope)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
            return
        }
        physicsObject.setMass(newMass)
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setPhysicsObject(_ physicsObject: PhysicsObject) {
        self.physicsObject = physicsObject
    }

    public func setMass(_ mass: Formula) {
        self.mass = mass
    }
}
