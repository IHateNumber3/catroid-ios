import Foundation

/// В Java — ContactListener; здесь колбэки B2World (preSolve/postSolve в оригинале пустые).
public final class PhysicsCollisionListener {
    public static let collisionMessageEscapeChar = "\t"
    public static let collisionMessageConnector = "<" + collisionMessageEscapeChar + "-" + collisionMessageEscapeChar + ">"

    private unowned let physicsWorld: PhysicsWorld
    private var collidingSpritesToCollisionMap: [CollidingSprites: PhysicalCollision] = [:]

    public init(physicsWorld: PhysicsWorld) {
        self.physicsWorld = physicsWorld
    }

    private func registerContact(_ s1: Sprite, _ s2: Sprite) {
        let key = CollidingSprites(s1, s2)
        if collidingSpritesToCollisionMap[key] == nil {
            collidingSpritesToCollisionMap[key] = PhysicalCollision(key)
        }
        collidingSpritesToCollisionMap[key]?.increaseContactCounter()
    }

    private func unregisterContact(_ s1: Sprite, _ s2: Sprite) {
        let key = CollidingSprites(s1, s2)
        if let collision = collidingSpritesToCollisionMap[key] {
            collision.decreaseContactCounter()
            if collision.contactCounter == 0 {
                collision.sendBounceOffEvents()
                collidingSpritesToCollisionMap.removeValue(forKey: key)
            }
        }
    }

    public func beginContact(_ a: B2Body, _ b: B2Body) {
        let ua = a.userData, ub = b.userData
        if let s = ua as? Sprite, let id = ub as? PhysicsBoundaryBox.BoundaryBoxIdentifier {
            physicsWorld.bouncedOnEdge(s, id)
        } else if let id = ua as? PhysicsBoundaryBox.BoundaryBoxIdentifier, let s = ub as? Sprite {
            physicsWorld.bouncedOnEdge(s, id)
        } else if let s1 = ua as? Sprite, let s2 = ub as? Sprite {
            registerContact(s1, s2)
        }
    }

    public func endContact(_ a: B2Body, _ b: B2Body) {
        if let s1 = a.userData as? Sprite, let s2 = b.userData as? Sprite {
            unregisterContact(s1, s2)
        }
    }
}
