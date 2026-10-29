import Foundation

final class PhysicsObjectStateHandler {

    private unowned let physicsLook: PhysicsLook
    private let physicsObject: PhysicsObject

    private typealias Condition = () -> Bool

    private var hangupConditions: [Condition] = []
    private var nonCollidingConditions: [Condition] = []
    private var fixConditions: [Condition] = []

    private var glideToIsActive = false
    private var hangedUp = false
    private var fixed = false
    private var nonColliding = false

    init(physicsLook: PhysicsLook, physicsObject: PhysicsObject) {
        self.physicsLook = physicsLook
        self.physicsObject = physicsObject

        let positionCondition: Condition = { [physicsObject] in
            let c = physicsObject.getMassCenter()
            let circ = physicsObject.getCircumference()
            let xOut = abs(PhysicsWorldConverter.convertBox2dToNormalCoordinate(c.x)) - circ > PhysicsWorld.activeArea.x / 2
            let yOut = abs(PhysicsWorldConverter.convertBox2dToNormalCoordinate(c.y)) - circ > PhysicsWorld.activeArea.y / 2
            return xOut || yOut
        }
        let visibleCondition: Condition = { [unowned physicsLook] in !physicsLook.isLookVisible }
        let transparencyCondition: Condition = { [unowned physicsLook] in physicsLook.alpha == 0.0 }
        let glideToCondition: Condition = { [unowned self] in self.glideToIsActive }

        hangupConditions = [transparencyCondition, positionCondition, visibleCondition, glideToCondition]
        nonCollidingConditions = [transparencyCondition, positionCondition, visibleCondition]
        fixConditions = [glideToCondition]
    }

    @discardableResult
    func checkHangup(_ record: Bool) -> Bool {
        let should = hangupConditions.contains { $0() }
        let deactivate = hangedUp && !should
        let activate = !hangedUp && should
        if deactivate {
            physicsObject.deactivateHangup(record)
        } else if activate {
            physicsObject.activateHangup()
        }
        hangedUp = should
        return hangedUp
    }

    @discardableResult
    private func checkNonColliding(_ record: Bool) -> Bool {
        let should = nonCollidingConditions.contains { $0() }
        let deactivate = nonColliding && !should
        let activate = !nonColliding && should
        if deactivate {
            physicsObject.deactivateNonColliding(record: record, updateState: false)
        } else if activate {
            physicsObject.activateNonColliding(updateState: false)
        }
        nonColliding = should
        return nonColliding
    }

    @discardableResult
    private func checkFixed(_ record: Bool) -> Bool {
        let should = fixConditions.contains { $0() }
        let deactivate = fixed && !should
        let activate = !fixed && should
        if deactivate {
            physicsObject.deactivateFixed(record)
        } else if activate {
            physicsObject.activateFixed()
        }
        fixed = should
        return fixed
    }

    func update(_ record: Bool) {
        checkHangup(record)
        checkNonColliding(record)
        checkFixed(record)
        updateRotation()
    }

    func updateRotation() {
        let rotationCondition = physicsLook.getRotationMode() != Look.rotationStyleAllAround
        physicsObject.setFixedRotation(rotationCondition)
    }

    func activateGlideTo() {
        if !glideToIsActive {
            glideToIsActive = true
            physicsLook.updatePhysicsObjectState(true)
        }
    }

    func deactivateGlideTo() {
        glideToIsActive = false
        physicsLook.updatePhysicsObjectState(true)
    }

    var isHangedUp: Bool { return hangedUp }

    func setNonColliding(_ value: Bool) {
        if nonColliding != value {
            nonColliding = value
            update(true)
        }
    }
}
