import Foundation

public final class PhysicsBoundaryBox {
    public static let frameSize = 5

    public enum BoundaryBoxIdentifier { case bbiHorizontal, bbiVertical }

    private let world: B2World
    /// B2Body удаляет себя из мира в deinit — рамку нужно держать
    private var bodies: [B2Body] = []

    public init(world: B2World) {
        self.world = world
    }

    public func create(width: Int, height: Int) {
        let boxWidth = PhysicsWorldConverter.convertNormalToBox2dCoordinate(Float(width))
        let boxHeight = PhysicsWorldConverter.convertNormalToBox2dCoordinate(Float(height))
        let boxElementSize = PhysicsWorldConverter.convertNormalToBox2dCoordinate(Float(PhysicsBoundaryBox.frameSize))
        let half = boxElementSize / 2

        createSide(center: Vector2(0, boxHeight / 2 + half), width: boxWidth, height: boxElementSize, id: .bbiHorizontal)
        createSide(center: Vector2(0, -(boxHeight / 2) - half), width: boxWidth, height: boxElementSize, id: .bbiHorizontal)
        createSide(center: Vector2(-(boxWidth / 2) - half, 0), width: boxElementSize, height: boxHeight, id: .bbiVertical)
        createSide(center: Vector2(boxWidth / 2 + half, 0), width: boxElementSize, height: boxHeight, id: .bbiVertical)
    }

    private func createSide(center: Vector2, width: Float, height: Float, id: BoundaryBoxIdentifier) {
        let body = world.createBody(type: .static, allowSleep: false)
        let shape = B2Shape.box(halfWidth: width / 2, halfHeight: height / 2,
                                center: CGPoint(x: CGFloat(center.x), y: CGFloat(center.y)), angle: 0)
        body.createFixture(shape: shape, density: 0, friction: 0.2, restitution: 0,
                           categoryBits: PhysicsWorld.categoryBoundaryBox,
                           maskBits: PhysicsWorld.maskBoundaryBox)
        body.userData = id
        bodies.append(body)
    }
}
