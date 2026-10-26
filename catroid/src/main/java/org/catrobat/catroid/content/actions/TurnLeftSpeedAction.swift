import Foundation

open class TurnLeftSpeedAction: TemporalAction {
    var scope: Scope!
    var physicsObject: PhysicsObject!
    var speed: Formula!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        var newSpeed: Float
        do {
            try newSpeed = speed == nil ? Float(0) : speed.interpretFloat(scope)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
            return
        }
        physicsObject.setRotationSpeed(newSpeed)
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setPhysicsObject(_ physicsObject: PhysicsObject) {
        self.physicsObject = physicsObject
    }

    public func setSpeed(_ speed: Formula) {
        self.speed = speed
    }
}
