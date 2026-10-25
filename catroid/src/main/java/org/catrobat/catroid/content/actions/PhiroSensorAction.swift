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

    public required init() { super.init() }

    open override func begin() {
        do {
            if ifCondition == nil {
                isInterpretedCorrectly = false
                return
            }
            var interpretation: Double = try ifCondition.interpretDouble(scope)
            ifConditionValue = interpretation.intValue <= DISTANCE_THRESHOLD_VALUE
            isInterpretedCorrectly = true
        } catch let interpretationException {
            isInterpretedCorrectly = false
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    open override func act(_ delta: Float) -> Bool {
        if !isInitialized {
            begin()
            isInitialized = true
        }
        if !isInterpretedCorrectly {
            return true
        }
        if ifConditionValue {
            return ifAction.act(delta)
        } else {
            return elseAction.act(delta)
        }
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
        self.setIfCondition(Formula(FormulaElement(FormulaElement.ElementType.sensor, getPhiroProSensorByNumber().name(), nil)))
    }

    private func getPhiroProSensorByNumber() -> Sensors {
        // TODO(port): switch (this.sensorNumber) { case 0: return Sensors.PHIRO_FRONT_LEFT;
        case 1: return Sensors.phiroFrontRight
        case 2: return Sensors.phiroSideLeft
        case 3: return Sensors.phiroSideRight
        case 4: return Sensors.phiroBottomLeft
        case 5: return Sensors.phiroBottomRight
        } return Sensors.phiroSideRight;
    }

    public func setActor(_ actor: Actor) {
        super.setActor(actor)
        ifAction.setActor(actor)
        elseAction.setActor(actor)
    }
}
