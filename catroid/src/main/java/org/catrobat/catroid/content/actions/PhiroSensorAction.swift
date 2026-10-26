import Foundation

open class PhiroSensorAction: Action {
    var sensorNumber: Int = 0
    var scope: Scope!
    var ifAction: Action!
    var elseAction: Action!
    var ifCondition: Formula!
    var ifConditionValue: Bool = false
    var isInitialized: Bool = false
    var isInterpretedCorrectly: Bool = false
    public static let DISTANCE_THRESHOLD_VALUE: Int = 850

    public override init() { super.init() }

    open override func begin() {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    open override func act(_ delta: Float) -> Bool {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
        return true
    }

    open override func restart() {
        ifAction.restart()
        elseAction.restart()
        isInitialized = false
        super.restart()
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setIfAction(_ ifAction: Action) {
        self.ifAction = ifAction
    }

    public func setElseAction(_ elseAction: Action) {
        self.elseAction = elseAction
    }

    public func setIfCondition(_ ifCondition: Formula) {
        self.ifCondition = ifCondition
    }

    public func setSensor(_ sensorNumber: Int) {
        self.sensorNumber = sensorNumber
        self.setIfCondition(Formula(FormulaElement(FormulaElement.ElementType.sensor, getPhiroProSensorByNumber().rawValue, nil)))
    }

    private func getPhiroProSensorByNumber() -> Sensors {
        switch sensorNumber {
        case 0: return .phiroFrontLeft
        case 1: return .phiroFrontRight
        case 2: return .phiroSideLeft
        case 3: return .phiroSideRight
        case 4: return .phiroBottomLeft
        case 5: return .phiroBottomRight
        default: return .phiroSideRight
        }
    }

    open override func actorDidChange() {
        ifAction?.actor = actor
        elseAction?.actor = actor
    }
}
