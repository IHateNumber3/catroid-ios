import Foundation

open class RaspiIfLogicAction: Action {
    public static let TAG: String = RaspiIfLogicAction.class.getSimpleName()
    var scope: Scope!
    var ifAction: Action!
    var elseAction: Action!
    var isInitialized: Bool = false
    var pinNumber: Formula!
    var pin: Int = 0

    public required init() { super.init() }

    public func setPinNumber(_ pinNumber: Formula) {
        self.pinNumber = pinNumber
    }

    open override func begin() {
        var pinNumberInterpretation: Int
        do {
            try pinNumberInterpretation = pinNumber == nil ? Int(0) : pinNumber.interpretInteger(scope)
        } catch let interpretationException {
            pinNumberInterpretation = 0
            Log.e(TAG, "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        self.pin = pinNumberInterpretation
    }

    open override func act(_ delta: Float) -> Bool {
        if !isInitialized {
            begin()
            isInitialized = true
        }
        if readIfConditionValue() {
            return ifAction.act(delta)
        } else {
            return elseAction.act(delta)
        }
    }

    func readIfConditionValue() -> Bool {
        var connection = RaspberryPiService.instance.connection
        do {
            Log.d(TAG, "RPi get " + pin)
            return connection.getPin(pin)
        } catch let e {
            Log.e(TAG, "RPi: exception during getPin: " + e)
        }
        return false
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

    public func setActor(_ actor: Actor) {
        super.setActor(actor)
        ifAction.setActor(actor)
        elseAction.setActor(actor)
    }
}
