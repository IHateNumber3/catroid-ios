import Foundation

open class ForVariableFromToAction: LoopAction {
    var controlVariable: UserVariable!
    var from: Formula!
    var to: Formula!
    var scope: Scope!
    var isCurrentLoopInitialized: Bool = false
    var isRepeatActionInitialized: Bool = false
    var fromValue: Int = 0
    var toValue: Int = 0
    var step: Int = 1

    public override init() { super.init() }

    open override func delegate(_ delta: Float) -> Bool {
        if !isRepeatActionInitialized && !interpretParameters() {
            return true
        }
        if !isCurrentLoopInitialized {
            setCurrentTime(0.0)
            isCurrentLoopInitialized = true
        }
        setCurrentTime(getCurrentTime() + delta)
        if action != nil && action.act(delta) && !isLoopDelayNeeded() {
            if !(controlVariable.value is Double) || (step > 0 && Double(controlVariable.value) >= toValue) || (step < 0 && Double(controlVariable.value) <= toValue) {
                return true
            }
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

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setRange(_ from: Formula, _ to: Formula) {
        self.from = from
        self.to = to
    }

    public func setControlVariable(_ variable: UserVariable) {
        controlVariable = variable
    }

    private func interpretParameters() -> Bool {
        isRepeatActionInitialized = true
        do {
            var fromInterpretation: Double = try from == nil ? Double(0) : from.interpretDouble(scope)
            fromValue = fromInterpretation.intValue
            var toInterpretation: Double = try to == nil ? Double(0) : to.interpretDouble(scope)
            toValue = toInterpretation.intValue
            setStepValue()
            setControlVariable(fromValue)
            return true
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
            return false
        }
    }

    private func setStepValue() {
        step = (fromValue <= toValue) ? 1 : -1
    }

    private func setControlVariable(_ value: Int) {
        controlVariable.setValue(Double(value))
    }

    private func changeControlVariable(_ value: Int) {
        controlVariable.setValue(Double(controlVariable.value) + Double(value))
    }
}
