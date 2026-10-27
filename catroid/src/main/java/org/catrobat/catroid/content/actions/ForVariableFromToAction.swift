import Foundation

open class ForVariableFromToAction: LoopAction {
    var controlVariable: UserVariable!
    var from: Formula!
    var to: Formula!
    var scope: Scope!
    var isCurrentLoopInitialized = false
    var isRepeatActionInitialized = false
    var fromValue = 0
    var toValue = 0
    var step = 1

    public required override init() { super.init() }

    open override func delegate(_ delta: Float) -> Bool {
        if !isRepeatActionInitialized && !interpretParameters() { return true }
        if !isCurrentLoopInitialized { currentTime = 0; isCurrentLoopInitialized = true }
        currentTime += delta
        if let action = action, action.act(delta), !isLoopDelayNeeded() {
            let currentValue = (controlVariable.value as? NSNumber)?.doubleValue ?? Double.nan
            if !currentValue.isFinite || (step > 0 && currentValue >= Double(toValue)) || (step < 0 && currentValue <= Double(toValue)) { return true }
            changeControlVariable(step)
            isCurrentLoopInitialized = false
            action.restart()
        }
        return false
    }

    open override func restart() {
        isCurrentLoopInitialized = false
        isRepeatActionInitialized = false
        super.restart()
    }
    public func setScope(_ scope: Scope) { self.scope = scope }
    public func setRange(_ from: Formula, _ to: Formula) { self.from = from; self.to = to }
    public func setControlVariable(_ variable: UserVariable) { controlVariable = variable }

    private func interpretParameters() -> Bool {
        isRepeatActionInitialized = true
        do {
            fromValue = Int(try from == nil ? 0.0 : from.interpretDouble(scope))
            toValue = Int(try to == nil ? 0.0 : to.interpretDouble(scope))
            step = fromValue <= toValue ? 1 : -1
            setControlVariable(fromValue)
            return true
        } catch {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", error)
            return false
        }
    }
    private func setControlVariable(_ value: Int) { controlVariable.setValue(Double(value)) }
    private func changeControlVariable(_ value: Int) {
        let current = (controlVariable.value as? NSNumber)?.doubleValue ?? 0
        controlVariable.setValue(current + Double(value))
    }
}
