import Foundation

open class WaitUntilAction: Action {
    var completed: Bool = false
    var condition: Formula!
    var scope: Scope!
    public static let LOOP_DELAY: Float = 0.02
    var currentTime: Float = 0

    public override init() { super.init() }

    public func setCondition(_ condition: Formula) {
        self.condition = condition
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    open override func act(_ delta: Float) -> Bool {
        if completed {
            return true
        }
        currentTime += delta
        if currentTime < WaitUntilAction.LOOP_DELAY {
            return false
        } else {
            currentTime = 0.0
        }
        do {
            try completed = condition.interpretBoolean(scope)
        } catch let e {
            completed = false
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", e)
        }
        return completed
    }

    open override func restart() {
        completed = false
    }
}
