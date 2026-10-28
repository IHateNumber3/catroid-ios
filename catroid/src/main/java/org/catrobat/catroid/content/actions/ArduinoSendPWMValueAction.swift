import Foundation

open class ArduinoSendPWMValueAction: TemporalAction {
    var pinNumber: Formula!
    var pinValue: Formula!
    var scope: Scope!
    var pin: Int = 0
    var value: Int = 0
    var restart: Bool = false

    public required init() { super.init() }

    open override func begin() {
        var pinNumberInterpretation: Int
        var pinValueInterpretation: Int
        do {
            try pinNumberInterpretation = pinNumber == nil ? Int(0) : pinNumber.interpretInteger(scope)
        } catch let interpretationException {
            pinNumberInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        do {
            try pinValueInterpretation = pinValue == nil ? Int(0) : pinValue.interpretInteger(scope)
        } catch let interpretationException {
            pinValueInterpretation = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        if (!restart) && (pinNumberInterpretation >= 0) && (pinNumberInterpretation < 14) {
            self.pin = pinNumberInterpretation
            self.value = pinValueInterpretation
        }
        restart = false
    }

    open override func update(_ percent: Float) {
        // Arduino Bluetooth transport is Android-specific; the iOS transport is not wired yet.
        // Keep this action safely inert until a CoreBluetooth implementation is connected.
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
