import Foundation

open class RaspiSendDigitalValueAction: TemporalAction {
    public static let TAG: String = String(describing: RaspiSendDigitalValueAction.self)
    var pinNumber: Formula!
    var pinValue: Formula!
    var scope: Scope!
    var pin: Int = 0
    var value: Bool = false

    public required init() { super.init() }

    open override func begin() {
        var pinNumberInterpretation: Int
        var pinValueInterpretation: Bool
        do {
            try pinNumberInterpretation = pinNumber == nil ? Int(0) : pinNumber.interpretInteger(scope)
        } catch let interpretationException {
            pinNumberInterpretation = 0
            Log.d(RaspiSendDigitalValueAction.TAG, "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        do {
            try pinValueInterpretation = pinValue != nil && pinValue.interpretBoolean(scope)
        } catch let interpretationException {
            pinValueInterpretation = false
            Log.d(RaspiSendDigitalValueAction.TAG, "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        self.pin = pinNumberInterpretation
        self.value = pinValueInterpretation
    }

    open override func update(_ percent: Float) {
        // Raspberry Pi GPIO transport is not available in this iOS port yet.
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setPinNumber(_ newPinNumber: Formula) {
        pinNumber = newPinNumber
    }

    public func setPinValue(_ newpinValue: Formula) {
        pinValue = newpinValue
    }
}
