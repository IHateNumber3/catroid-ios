import Foundation

open class GlideToPhysicsAction: GlideToAction {
    var physicsLook: PhysicsLook!

    public override init() { super.init() }

    open override func begin() {
        physicsLook.startGlide()
        super.begin()
    }

    open override func end() {
        super.end()
        physicsLook.stopGlide()
    }

    public func setPhysicsLook(_ physicsLook: PhysicsLook) {
        self.physicsLook = physicsLook
    }
}
