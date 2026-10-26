import Foundation

open class SetPhysicsObjectTypeAction: TemporalAction {
    var physicsObject: PhysicsObject!
    var type: PhysicsObject.PhysicsType = .none

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        physicsObject.setType(type)
    }

    public func setPhysicsObject(_ physicsObject: PhysicsObject) {
        self.physicsObject = physicsObject
    }

    public func setType(_ type: PhysicsObject.PhysicsType) {
        self.type = type
    }
}
