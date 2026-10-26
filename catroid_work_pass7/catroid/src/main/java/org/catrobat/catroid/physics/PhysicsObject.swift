import Foundation

public final class PhysicsObject {

    public enum PhysicsType { case dynamic, fixed, none }

    public static let defaultDensity: Float = 1.0
    public static let defaultFriction: Float = 0.2
    public static let maxFriction: Float = 1.0
    public static let minFriction: Float = 0.0
    public static let minDensity: Float = 0.0
    public static let minBounceFactor: Float = 0.0
    public static let defaultBounceFactor: Float = 0.8
    public static let defaultMass: Float = 1.0
    public static let minMass: Float = 0.000001

    private var collisionMaskRecord: UInt16 = 0
    private var categoryMaskRecord: UInt16 = PhysicsWorld.categoryPhysicsObject

    private let body: B2Body
    // FixtureDef
    private var density: Float = PhysicsObject.defaultDensity
    private var friction: Float = PhysicsObject.defaultFriction
    private var restitution: Float = PhysicsObject.defaultBounceFactor
    private var filterCategory: UInt16 = 0
    private var filterMask: UInt16 = 0

    private var shapes: [B2Shape]?
    private var type: PhysicsType?
    private var mass: Float
    private var circumference: Float = 0
    private var ifOnEdgeBounce = false

    private var bodyAabbLowerLeft = Vector2()
    private var bodyAabbUpperRight = Vector2()

    private var velocity = Vector2()
    private var rotationSpeed: Float = 0
    private var gravityScaleStorage: Float = 0
    private var savedType: PhysicsType = .none

    public init(body: B2Body, sprite: Sprite) {
        self.body = body
        body.userData = sprite
        mass = PhysicsObject.defaultMass
        setType(.none)
    }

    public func copyTo(_ destination: PhysicsObject) {
        destination.setType(getType())
        destination.setPosition(getPosition())
        destination.setDirection(getDirection())
        destination.setMass(getMass())
        destination.setRotationSpeed(getRotationSpeed())
        destination.setBounceFactor(getBounceFactor())
        destination.setFriction(getFriction())
        destination.setVelocity(getVelocity())
    }

    // MARK: - Shapes

    public func setShape(_ newShapes: [B2Shape]?) {
        // Arrays.equals по ссылкам (у gdx Shape нет equals)
        if sameShapes(shapes, newShapes) { return }
        shapes = newShapes

        body.destroyAllFixtures()
        if let list = newShapes {
            for shape in list {
                body.createFixture(shape: shape, density: density, friction: friction, restitution: restitution,
                                   categoryBits: filterCategory, maskBits: filterMask)
            }
        }
        setMass(mass)
        calculateCircumference()
    }

    private func sameShapes(_ a: [B2Shape]?, _ b: [B2Shape]?) -> Bool {
        switch (a, b) {
        case (nil, nil): return true
        case let (x?, y?): return x.count == y.count && zip(x, y).allSatisfy { $0 === $1 }
        default: return false
        }
    }

    private func calculateCircumference() {
        if body.fixtures.isEmpty {
            circumference = 0
            return
        }
        circumference = PhysicsWorldConverter.convertNormalToBox2dCoordinate(getBoundaryBoxDimensions().len() / 2)
    }

    // MARK: - Type

    public func getType() -> PhysicsType { return type ?? .none }

    public func setType(_ newType: PhysicsType) {
        if type == newType { return }
        type = newType
        switch newType {
        case .dynamic:
            body.type = .dynamic
            body.gravityScale = 1
            body.bullet = true
            setMass(mass)
            collisionMaskRecord = PhysicsWorld.maskPhysicsObject
        case .fixed:
            body.type = .kinematic
            collisionMaskRecord = PhysicsWorld.maskPhysicsObject
        case .none:
            body.type = .kinematic
            collisionMaskRecord = PhysicsWorld.maskNoCollision
        }
        calculateCircumference()
        setCollisionBits(categoryMaskRecord, collisionMaskRecord)
    }

    // MARK: - Position / direction

    public func getDirection() -> Float { return PhysicsWorldConverter.convertBox2dToNormalAngle(body.angle) }

    public func setDirection(_ degrees: Float) {
        body.setTransform(x: Float(body.position.x), y: Float(body.position.y),
                          angle: PhysicsWorldConverter.convertNormalToBox2dAngle(degrees))
    }

    public func getX() -> Float { return PhysicsWorldConverter.convertBox2dToNormalCoordinate(Float(body.position.x)) }
    public func getY() -> Float { return PhysicsWorldConverter.convertBox2dToNormalCoordinate(Float(body.position.y)) }

    public func getMassCenter() -> Vector2 {
        let c = body.worldCenter
        return Vector2(Float(c.x), Float(c.y))
    }

    public func getCircumference() -> Float {
        return PhysicsWorldConverter.convertBox2dToNormalCoordinate(circumference)
    }

    public func getPosition() -> Vector2 {
        return PhysicsWorldConverter.convertBox2dToNormalVector(Vector2(Float(body.position.x), Float(body.position.y)))
    }

    public func setX(_ x: Float) {
        body.setTransform(x: PhysicsWorldConverter.convertNormalToBox2dCoordinate(x),
                          y: Float(body.position.y), angle: body.angle)
    }

    public func setY(_ y: Float) {
        body.setTransform(x: Float(body.position.x),
                          y: PhysicsWorldConverter.convertNormalToBox2dCoordinate(y), angle: body.angle)
    }

    public func setPosition(_ x: Float, _ y: Float) {
        body.setTransform(x: PhysicsWorldConverter.convertNormalToBox2dCoordinate(x),
                          y: PhysicsWorldConverter.convertNormalToBox2dCoordinate(y), angle: body.angle)
    }

    public func setPosition(_ p: Vector2) { setPosition(p.x, p.y) }

    // MARK: - Velocity

    public func getRotationSpeed() -> Float { return Float(Double(body.angularVelocity) * 180 / .pi) }
    public func setRotationSpeed(_ degreesPerSecond: Float) {
        body.angularVelocity = Float(Double(degreesPerSecond) * .pi / 180)
    }

    public func getVelocity() -> Vector2 {
        let v = body.linearVelocity
        return PhysicsWorldConverter.convertBox2dToNormalVector(Vector2(Float(v.x), Float(v.y)))
    }

    public func setVelocity(_ x: Float, _ y: Float) {
        body.linearVelocity = CGPoint(x: CGFloat(PhysicsWorldConverter.convertNormalToBox2dCoordinate(x)),
                                      y: CGFloat(PhysicsWorldConverter.convertNormalToBox2dCoordinate(y)))
    }
    public func setVelocity(_ v: Vector2) { setVelocity(v.x, v.y) }

    // MARK: - Mass / density / friction / bounce

    public func getMass() -> Float { return mass }
    public func getBounceFactor() -> Float { return restitution }

    public func setMass(_ newMass: Float) {
        var m = newMass
        mass = m
        if m < 0 { mass = PhysicsObject.minMass }
        if m < PhysicsObject.minMass { m = PhysicsObject.minMass }
        if isStaticObject() { return }
        let area = body.mass / density
        let d = m / area
        setDensity(d)
    }

    private func isStaticObject() -> Bool { return body.mass == 0.0 }

    public func setDensity(_ newDensity: Float) {
        var d = newDensity
        if d < PhysicsObject.minDensity { d = PhysicsObject.minDensity }
        density = d
        for fixture in body.fixtures { fixture.density = d }
        body.resetMassData()
    }

    public func getFriction() -> Float { return friction }

    public func setFriction(_ newFriction: Float) {
        var f = newFriction
        if f < PhysicsObject.minFriction { f = PhysicsObject.minFriction }
        if f > PhysicsObject.maxFriction { f = PhysicsObject.maxFriction }
        friction = f
        for fixture in body.fixtures { fixture.friction = f }
    }

    public func setBounceFactor(_ newBounce: Float) {
        var b = newBounce
        if b < PhysicsObject.minBounceFactor { b = PhysicsObject.minBounceFactor }
        restitution = b
        for fixture in body.fixtures { fixture.restitution = b }
    }

    public func setGravityScale(_ scale: Float) { body.gravityScale = scale }
    public func getGravityScale() -> Float { return body.gravityScale }
    public func setFixedRotation(_ flag: Bool) { body.fixedRotation = flag }

    // MARK: - Collision bits

    public func setIfOnEdgeBounce(_ bounce: Bool, sprite: Sprite) {
        if ifOnEdgeBounce == bounce { return }
        ifOnEdgeBounce = bounce
        let maskBits: UInt16
        if bounce {
            maskBits = PhysicsWorld.maskToBounce
            body.userData = sprite
        } else {
            maskBits = PhysicsWorld.maskPhysicsObject
        }
        setCollisionBits(categoryMaskRecord, maskBits)
    }

    func setCollisionBits(_ categoryBits: UInt16, _ maskBits: UInt16, updateState: Bool = true) {
        filterCategory = categoryBits
        filterMask = maskBits
        for fixture in body.fixtures {
            fixture.categoryBits = categoryBits
            fixture.maskBits = maskBits
        }
        if updateState { updateNonCollidingState() }
    }

    private func updateNonCollidingState() {
        if let sprite = body.userData as? Sprite, let look = sprite.look as? PhysicsLook {
            look.setNonColliding(isNonColliding())
        }
    }

    // MARK: - Bounding box

    public func getBoundaryBox(lowerLeft: inout Vector2, upperRight: inout Vector2) {
        calculateAabb()
        lowerLeft = PhysicsWorldConverter.convertBox2dToNormalVector(bodyAabbLowerLeft)
        upperRight = PhysicsWorldConverter.convertBox2dToNormalVector(bodyAabbUpperRight)
    }

    public func getBoundaryBoxDimensions() -> Vector2 {
        calculateAabb()
        let w = PhysicsWorldConverter.convertBox2dToNormalCoordinate(abs(bodyAabbUpperRight.x - bodyAabbLowerLeft.x)) + 1
        let h = PhysicsWorldConverter.convertBox2dToNormalCoordinate(abs(bodyAabbUpperRight.y - bodyAabbLowerLeft.y)) + 1
        return Vector2(w, h)
    }

    private func calculateAabb() {
        bodyAabbLowerLeft = Vector2(Float(Int32.max), Float(Int32.max))
        bodyAabbUpperRight = Vector2(Float(Int32.min), Float(Int32.min))
        let fixtures = body.fixtures
        if fixtures.isEmpty {
            bodyAabbLowerLeft = Vector2(0, 0)
            bodyAabbUpperRight = Vector2(0, 0)
        }
        for fixture in fixtures { calculateAabb(fixture) }
    }

    private func calculateAabb(_ fixture: B2Fixture) {
        var lower = Vector2(Float(Int32.max), Float(Int32.max))
        var upper = Vector2(Float(Int32.min), Float(Int32.min))
        let shape = fixture.shape
        if shape.type == .circle {
            let radius = shape.radius
            // как в Java: rotate() принимает градусы, а передаётся угол в радианах (сохранено намеренно)
            var t = Vector2(Float(shape.position.x), Float(shape.position.y)).rotated(degrees: body.angle)
            t = t + Vector2(Float(body.position.x), Float(body.position.y))
            lower = Vector2(t.x - radius, t.y - radius)
            upper = Vector2(t.x + radius, t.y + radius)
        } else if shape.type == .polygon {
            let count = Int(shape.vertexCount)
            var p = body.worldPoint(local: shape.vertex(at: 0))
            lower = Vector2(Float(p.x), Float(p.y))
            upper = lower
            if count > 1 {
                for i in 1..<count {
                    p = body.worldPoint(local: shape.vertex(at: i))
                    lower.x = min(lower.x, Float(p.x)); lower.y = min(lower.y, Float(p.y))
                    upper.x = max(upper.x, Float(p.x)); upper.y = max(upper.y, Float(p.y))
                }
            }
        }
        bodyAabbLowerLeft.x = min(lower.x, bodyAabbLowerLeft.x)
        bodyAabbLowerLeft.y = min(lower.y, bodyAabbLowerLeft.y)
        bodyAabbUpperRight.x = max(upper.x, bodyAabbUpperRight.x)
        bodyAabbUpperRight.y = max(upper.y, bodyAabbUpperRight.y)
    }

    // MARK: - Hangup / non-colliding / fixed

    public func activateHangup() {
        velocity = getVelocity()
        rotationSpeed = getRotationSpeed()
        gravityScaleStorage = getGravityScale()
        setGravityScale(0)
        setVelocity(0, 0)
        setRotationSpeed(0)
    }

    public func deactivateHangup(_ record: Bool) {
        if record {
            setGravityScale(gravityScaleStorage)
            setVelocity(velocity.x, velocity.y)
            setRotationSpeed(rotationSpeed)
        } else {
            setGravityScale(1)
        }
    }

    public func activateNonColliding(updateState: Bool) {
        setCollisionBits(categoryMaskRecord, PhysicsWorld.maskNoCollision, updateState: updateState)
    }

    public func deactivateNonColliding(record: Bool, updateState: Bool) {
        if record {
            setCollisionBits(categoryMaskRecord, collisionMaskRecord, updateState: updateState)
        }
    }

    public func activateFixed() {
        savedType = getType()
        setType(.fixed)
    }

    public func deactivateFixed(_ record: Bool) {
        if record { setType(savedType) }
    }

    public func isNonColliding() -> Bool {
        return collisionMaskRecord == PhysicsWorld.maskNoCollision
    }
}
