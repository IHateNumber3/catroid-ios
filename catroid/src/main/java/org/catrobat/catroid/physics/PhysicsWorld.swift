import Foundation

public final class PhysicsWorld {

    public static let categoryNoCollision: UInt16 = 0x0000
    public static let categoryBoundaryBox: UInt16 = 0x0002
    public static let categoryPhysicsObject: UInt16 = 0x0004
    public static let maskBoundaryBox: UInt16 = categoryPhysicsObject      // сталкивается с physics-объектами
    public static let maskPhysicsObject: UInt16 = ~categoryBoundaryBox     // со всем, кроме рамки
    public static let maskToBounce: UInt16 = 0xFFFF                        // Java: -1, со всем
    public static let maskNoCollision: UInt16 = 0

    public static let activeAreaWidthFactor: Float = 3.0
    public static let activeAreaHeightFactor: Float = 2.0
    public static let ratio: Float = 10.0
    public static let velocityIterations: Int32 = 3
    public static let positionIterations: Int32 = 3
    public static let defaultGravity = Vector2(0, -10)
    public static let ignoreSleepingObjects = false
    public static var activeArea = Vector2()
    public static let stabilizingSteps = 6

    private let world: B2World
    private var physicsObjects: [Sprite: PhysicsObject] = [:]
    private var activeVerticalBounces: [Sprite] = []
    private var activeHorizontalBounces: [Sprite] = []
    private var stabilizingStepCounter = 0
    private let boundaryBox: PhysicsBoundaryBox
    private let physicsShapeBuilder = PhysicsShapeBuilder.shared
    private var collisionListener: PhysicsCollisionListener?

    public convenience init() {
        let r = ScreenValues.currentScreenResolution ?? Resolution(1280, 768)
        self.init(width: r.width, height: r.height)
    }

    public init(width: Int, height: Int) {
        world = B2World(gravityX: PhysicsWorld.defaultGravity.x, y: PhysicsWorld.defaultGravity.y,
                        allowSleep: PhysicsWorld.ignoreSleepingObjects)
        boundaryBox = PhysicsBoundaryBox(world: world)
        boundaryBox.create(width: width, height: height)
        PhysicsWorld.activeArea = Vector2(Float(width) * PhysicsWorld.activeAreaWidthFactor,
                                          Float(height) * PhysicsWorld.activeAreaHeightFactor)
        let listener = PhysicsCollisionListener(physicsWorld: self)
        collisionListener = listener
        world.beginContact = { [weak listener] a, b in listener?.beginContact(a, b) }
        world.endContact = { [weak listener] a, b in listener?.endContact(a, b) }
    }

    public func setBounceOnce(_ sprite: Sprite, _ id: PhysicsBoundaryBox.BoundaryBoxIdentifier) {
        guard let object = physicsObjects[sprite] else { return }
        object.setIfOnEdgeBounce(true, sprite: sprite)
        switch id {
        case .bbiHorizontal: activeHorizontalBounces.append(sprite)
        case .bbiVertical: activeVerticalBounces.append(sprite)
        }
    }

    public func step(_ deltaTime: Float) {
        if stabilizingStepCounter < PhysicsWorld.stabilizingSteps {
            stabilizingStepCounter += 1
        } else {
            world.step(delta: deltaTime,
                       velocityIterations: PhysicsWorld.velocityIterations,
                       positionIterations: PhysicsWorld.positionIterations)
        }
    }

    /// Debug-рендер отключён (все PhysicsDebugSettings.Render = false)
    public func render() {}

    public func setGravity(_ x: Float, _ y: Float) {
        world.gravity = CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    public var gravity: Vector2 {
        let g = world.gravity
        return Vector2(Float(g.x), Float(g.y))
    }

    public func changeLook(_ physicsObject: PhysicsObject, look: Look) {
        var shapes: [B2Shape]?
        if let lookData = look.lookData, lookData.file != nil {
            shapes = physicsShapeBuilder.getScaledShapes(lookData, scaleFactor: look.sizeInUserInterfaceDimensionUnit / 100)
        }
        physicsObject.setShape(shapes)
    }

    public func getPhysicsObject(_ sprite: Sprite) -> PhysicsObject {
        if let existing = physicsObjects[sprite] { return existing }
        let object = createPhysicsObject(sprite)
        physicsObjects[sprite] = object
        return object
    }

    private func createPhysicsObject(_ sprite: Sprite) -> PhysicsObject {
        // BodyDef по умолчанию = StaticBody, allowSleep = true
        let body = world.createBody(type: .static, allowSleep: true)
        return PhysicsObject(body: body, sprite: sprite)
    }

    public func bouncedOnEdge(_ sprite: Sprite, _ id: PhysicsBoundaryBox.BoundaryBoxIdentifier) {
        guard let object = physicsObjects[sprite] else { return }
        switch id {
        case .bbiHorizontal:
            if let i = activeHorizontalBounces.firstIndex(of: sprite) {
                activeHorizontalBounces.remove(at: i)
                if !activeVerticalBounces.contains(sprite) {
                    object.setIfOnEdgeBounce(false, sprite: sprite)
                    PhysicalCollision.fireBounceOffEvent(sprite, nil)
                }
            }
        case .bbiVertical:
            if let i = activeVerticalBounces.firstIndex(of: sprite) {
                activeVerticalBounces.remove(at: i)
                if !activeHorizontalBounces.contains(sprite) {
                    object.setIfOnEdgeBounce(false, sprite: sprite)
                    PhysicalCollision.fireBounceOffEvent(sprite, nil)
                }
            }
        }
    }
}
