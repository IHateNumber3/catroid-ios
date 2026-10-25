import Foundation

public final class PhysicsLook: Look {

    public static let scaleFactorAccuracy: Float = 10000.0
    private static let fullCircleDegree: Float = 360
    private static let halfCircleDegree: Float = 180

    // nil пока работает super.init (как null в Java-конструкторе)
    private var physicsObject: PhysicsObject?
    private var physicsObjectStateHandler: PhysicsObjectStateHandler!
    private var isFlippedByAction = false

    public init(sprite: Sprite, physicsWorld: PhysicsWorld) {
        super.init(sprite: sprite)
        let object = physicsWorld.getPhysicsObject(sprite)
        physicsObject = object
        physicsObjectStateHandler = PhysicsObjectStateHandler(physicsLook: self, physicsObject: object)
    }

    // MARK: - Copy

    public override func copyTo(_ destination: Look) {
        super.copyTo(destination)
        if let dest = destination as? PhysicsLook, let object = physicsObject, let destObject = dest.physicsObject {
            object.copyTo(destObject)
        }
    }

    // MARK: - Look data / transparency / visibility

    public override func setTransparencyInUserInterfaceDimensionUnit(_ percent: Float) {
        super.setTransparencyInUserInterfaceDimensionUnit(percent)
        updatePhysicsObjectState(true)
    }

    public override func setLookData(_ lookData: LookData?) {
        super.setLookData(lookData)
        if let object = physicsObject {
            ProjectManager.shared.currentlyPlayingScene.getPhysicsWorld().changeLook(object, look: self)
        }
        updatePhysicsObjectState(true)
    }

    public override func setLookVisible(_ visible: Bool) {
        super.setLookVisible(visible)
        physicsObjectStateHandler?.update(true)
    }

    public override func willRender() {
        physicsObjectStateHandler?.checkHangup(true)
    }

    // MARK: - Position

    public override func setXInUserInterfaceDimensionUnit(_ x: Float) {
        setX(applyCenterOffset(x, isXCoordinate: true, add: false))
    }

    public override func setPosition(_ x: Float, _ y: Float) {
        super.setPosition(x, y)
        if let object = physicsObject {
            object.setX(applyCenterOffset(x, isXCoordinate: true, add: true))
            object.setY(applyCenterOffset(y, isXCoordinate: false, add: true))
        }
    }

    public override func setX(_ x: Float) {
        super.setX(x)
        physicsObject?.setX(applyCenterOffset(x, isXCoordinate: true, add: true))
    }

    public override func setY(_ y: Float) {
        super.setY(y)
        physicsObject?.setY(applyCenterOffset(y, isXCoordinate: false, add: true))
    }

    public override var x: Float {
        guard let object = physicsObject else { return super.x }
        let value = applyCenterOffset(object.getX(), isXCoordinate: true, add: false)
        super.setX(value)
        return value
    }

    public override var y: Float {
        guard let object = physicsObject else { return super.y }
        let value = applyCenterOffset(object.getY(), isXCoordinate: false, add: false)
        super.setY(value)
        return value
    }

    // MARK: - Velocity

    public override var angularVelocityInUserInterfaceDimensionUnit: Float {
        return physicsObject?.getRotationSpeed() ?? 0
    }

    public override var xVelocityInUserInterfaceDimensionUnit: Float {
        if let s = sprite, s.isGliding { return s.glidingVelocityX }
        return physicsObject?.getVelocity().x ?? 0
    }

    public override var yVelocityInUserInterfaceDimensionUnit: Float {
        if let s = sprite, s.isGliding { return s.glidingVelocityY }
        return physicsObject?.getVelocity().y ?? 0
    }

    // MARK: - Direction / rotation

    public override var motionDirectionInUserInterfaceDimensionUnit: Float {
        guard let object = physicsObject, isLookMoving() else {
            return super.motionDirectionInUserInterfaceDimensionUnit
        }
        let v = object.getVelocity()
        let motionDirection = Look.degreeUIOffset - Float(atan2(Double(v.y), Double(v.x)) * 180 / .pi)
        return breakDownCatroidAngle(motionDirection)
    }

    public override var lookDirectionInUserInterfaceDimensionUnit: Float {
        switch getRotationMode() {
        case Look.rotationStyleNone: return Look.degreeUIOffset
        case Look.rotationStyleAllAround: return convertStageAngleToCatroidAngle(rotation)
        case Look.rotationStyleLeftRightOnly: return isFlipped() ? -Look.degreeUIOffset : Look.degreeUIOffset
        default: return 0
        }
    }

    public override var rotation: Float {
        guard let object = physicsObject else { return super.rotation }
        super.setRotation(object.getDirection().truncatingRemainder(dividingBy: Self.fullCircleDegree))
        let current = super.rotation
        var realRotation = object.getDirection().truncatingRemainder(dividingBy: Self.fullCircleDegree)
        if realRotation < 0 { realRotation += Self.fullCircleDegree }
        switch getRotationMode() {
        case Look.rotationStyleNone:
            super.setRotation(0)
        case Look.rotationStyleAllAround:
            super.setRotation(current)
        case Look.rotationStyleLeftRightOnly:
            super.setRotation(0)
            flipLookDataIfNeeded(realRotation: realRotation)
        default: break
        }
        return super.rotation
    }

    public override func setRotation(_ degrees: Float) {
        super.setRotation(degrees)
        physicsObject?.setDirection(super.rotation.truncatingRemainder(dividingBy: Self.fullCircleDegree))
    }

    public override func setRotationMode(_ mode: Int) {
        super.setRotationMode(mode)
        updatePhysicsObjectState(true)
    }

    public override func setScale(_ scaleX: Float, _ scaleY: Float) {
        var sx = scaleX, sy = scaleY
        let oldX = self.scaleX, oldY = self.scaleY
        if sx < 0 || sy < 0 { sx = 0; sy = 0 }
        let acc = Self.scaleFactorAccuracy
        let scaleXComp = Int((sx * acc).rounded()), scaleYComp = Int((sy * acc).rounded())
        let oldXComp = Int((oldX * acc).rounded()), oldYComp = Int((oldY * acc).rounded())
        if scaleXComp == oldXComp && scaleYComp == oldYComp { return }
        super.setScale(sx, sy)
        if let object = physicsObject {
            ProjectManager.shared.currentlyPlayingScene.getPhysicsWorld().changeLook(object, look: self)
            updatePhysicsObjectState(true)
        }
    }

    // MARK: - State

    public func updatePhysicsObjectState(_ record: Bool) {
        physicsObjectStateHandler?.update(record)
    }

    public var isHangedUp: Bool { return physicsObjectStateHandler?.isHangedUp ?? false }
    public func setNonColliding(_ nonColliding: Bool) { physicsObjectStateHandler?.setNonColliding(nonColliding) }
    public func startGlide() { physicsObjectStateHandler?.activateGlideTo() }
    public func stopGlide() { physicsObjectStateHandler?.deactivateGlideTo() }

    // MARK: - Flip

    public func updateFlippedByAction() { isFlippedByAction.toggle() }

    public func setFlippedByDegree(_ degree: Float) {
        let direction = motionDirectionInUserInterfaceDimensionUnit
        let newDirection = (degree + direction).truncatingRemainder(dividingBy: Self.fullCircleDegree)
        setFlippedByDirection(newDirection)
    }

    public func setFlippedByDirection(_ newDirectionIn: Float) {
        var newDirection = newDirectionIn.truncatingRemainder(dividingBy: Self.fullCircleDegree)
        if newDirection < 0 { newDirection += Self.fullCircleDegree }
        let direction = motionDirectionInUserInterfaceDimensionUnit - Look.degreeUIOffset
        let half = Self.halfCircleDegree
        if (direction >= 0 && direction <= half) != (newDirection >= 0 && newDirection <= half) {
            updateFlippedByAction()
        }
    }

    private func isLookMoving() -> Bool {
        guard let v = physicsObject?.getVelocity() else { return false }
        return v.y != 0.0 || v.x != 0.0
    }

    private func flipLookDataIfNeeded(realRotation: Float) {
        let orientedRight = realRotation > Self.halfCircleDegree || realRotation == 0
        let orientedLeft = realRotation <= Self.halfCircleDegree && realRotation != 0
        var isLookDataFlipped = isFlipped()
        if isFlippedByAction { isLookDataFlipped.toggle() }
        if let lookData = lookData, (isLookDataFlipped && orientedRight) || (!isLookDataFlipped && orientedLeft) {
            lookData.getTextureRegion().flip(x: true, y: false)
        }
    }

    private func applyCenterOffset(_ coordinate: Float, isXCoordinate: Bool, add: Bool) -> Float {
        let screenParam = isXCoordinate ? width : height
        return add ? coordinate + screenParam / 2 : coordinate - screenParam / 2
    }
}
