import Foundation
import os

public final class ConditionScriptTrigger: Hashable {

    enum TriggerStatus {
        case triggerNow
        case alreadyTriggered
    }

    static let evaluateAndTriggerActionsThreshold: Int64 = 200

    private static let logger = Logger(subsystem: "org.catrobat.catroid",
                                       category: "ConditionScriptTrigger")

    private var sceneFirstStart = false
    private var sceneRestarted = false
    private var sceneAlreadyStarted = false
    private var startTime: Int64 = 0
    private var status: TriggerStatus = .triggerNow
    private let formula: Formula

    init(formula: Formula) {
        self.formula = formula
    }

    /// Аналог SystemClock.uptimeMillis()
    private static func uptimeMillis() -> Int64 {
        return Int64(ProcessInfo.processInfo.systemUptime * 1000)
    }

    func evaluateAndTriggerActions(sprite: Sprite) {
        do {
            let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: nil)
            var conditionValue = false

            if sceneFirstStart || sceneRestarted {
                if startTime == 0 {
                    startTime = Self.uptimeMillis()
                } else {
                    let elapsed = Self.uptimeMillis() - startTime
                    if elapsed >= Self.evaluateAndTriggerActionsThreshold {
                        if sceneFirstStart {
                            sceneFirstStart = false
                        } else if sceneRestarted {
                            sceneRestarted = false
                        }
                        startTime = 0
                        conditionValue = try formula.interpretBoolean(scope)
                    }
                }
            } else {
                conditionValue = try formula.interpretBoolean(scope)
            }

            if conditionValue {
                triggerScript(sprite: sprite)
            } else {
                status = .triggerNow
            }
        } catch {
            Self.logger.error("\(String(describing: error))")
        }
    }

    private func triggerScript(sprite: Sprite) {
        if status == .triggerNow {
            let wrapper = EventWrapper(eventId: WhenConditionEventId(formula: formula), waitForCompletion: false)
            sprite.look.fire(wrapper)
            status = .alreadyTriggered
        }
    }

    public func updateSceneFirstStart() {
        sceneFirstStart = true
        sceneAlreadyStarted = true
    }

    public func resetStartTimeIfSceneRestarted() {
        if sceneAlreadyStarted {
            startTime = 0
            sceneRestarted = true
            sceneFirstStart = false
        }
    }

    // MARK: - Hashable (по формуле, как в Java)

    public static func == (lhs: ConditionScriptTrigger, rhs: ConditionScriptTrigger) -> Bool {
        return lhs === rhs || lhs.formula == rhs.formula
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(formula)
    }
}
