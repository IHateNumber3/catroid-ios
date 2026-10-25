import Foundation

open class SetGravityAction: TemporalAction {
    var scope: Scope!
    var physicsWorld: PhysicsWorld!
    var gravityX: Formula!
    var gravityY: Formula!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var newGravityX: Float
        do {
            try newGravityX = gravityX == nil ? Float(0) : gravityX.interpretFloat(scope)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
            return
        }
        var newGravityY: Float
        do {
            try newGravityY = gravityY == nil ? Float(0) : gravityY.interpretFloat(scope)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
            return
        }
        physicsWorld.setGravity(newGravityX, newGravityY)
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setPhysicsWorld(_ physicsWorld: PhysicsWorld) {
        self.physicsWorld = physicsWorld
    }

    public func setGravity(_ gravityX: Formula, _ gravityY: Formula) {
        self.gravityX = gravityX
        self.gravityY = gravityY
    }
}
