import Foundation

open class SetVelocityAction: TemporalAction {
    var scope: Scope!
    var physicsObject: PhysicsObject!
    var velocityX: Formula!
    var velocityY: Formula!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        var newVelocityX: Float
        do {
            try newVelocityX = velocityX == nil ? Float(0) : velocityX.interpretFloat(scope)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
            return
        }
        var newVelocityY: Float
        do {
            try newVelocityY = velocityY == nil ? Float(0) : velocityY.interpretFloat(scope)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
            return
        }
        physicsObject.setVelocity(newVelocityX, newVelocityY)
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setPhysicsObject(_ physicsObject: PhysicsObject) {
        self.physicsObject = physicsObject
    }

    public func setVelocity(_ velocityX: Formula, _ velocityY: Formula) {
        self.velocityX = velocityX
        self.velocityY = velocityY
    }
}
