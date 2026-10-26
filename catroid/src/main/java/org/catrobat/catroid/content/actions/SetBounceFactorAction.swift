import Foundation

open class SetBounceFactorAction: TemporalAction {
    var scope: Scope!
    var physicsObject: PhysicsObject!
    var bounceFactor: Formula!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        var newBounceFactor: Float
        do {
            try newBounceFactor = bounceFactor == nil ? Float(0) : bounceFactor.interpretFloat(scope)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
            return
        }
        physicsObject.setBounceFactor(newBounceFactor / 100.0)
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setPhysicsObject(_ physicsObject: PhysicsObject) {
        self.physicsObject = physicsObject
    }

    public func setBounceFactor(_ bounceFactor: Formula) {
        self.bounceFactor = bounceFactor
    }
}
