import Foundation

open class RaspiPwmAction: TemporalAction {
    public static let TAG: String = RaspiPwmAction.class.getSimpleName()
    var pinNumberFormula: Formula!
    var pwmFrequencyFormula: Formula!
    var pwmPercentageFormula: Formula!
    var scope: Scope!
    var pinInterpretation: Int = 0
    var frequencyInterpretation: Double = 0
    var percentageInterpretation: Double = 0

    public required init() { super.init() }

    open override func begin() {
        do {
            try pinInterpretation = pinNumberFormula == nil ? Int(0) : pinNumberFormula.interpretInteger(scope)
        } catch let interpretationException {
            pinInterpretation = 0
            Log.d(TAG, "Formula interpretation for this specific Brick failed. (pin)", interpretationException)
        }
        do {
            try frequencyInterpretation = pwmFrequencyFormula == nil ? Double(0) : pwmFrequencyFormula .interpretDouble(scope)
        } catch let interpretationException {
            frequencyInterpretation = 0
            Log.d(TAG, "Formula interpretation for this specific Brick failed. (frequency)", interpretationException)
        }
        do {
            try percentageInterpretation = pwmPercentageFormula == nil ? Double(0) : pwmPercentageFormula .interpretDouble(scope)
        } catch let interpretationException {
            percentageInterpretation = 0
            Log.d(TAG, "Formula interpretation for this specific Brick failed. (percentage)", interpretationException)
        }
    }

    open override func update(_ percent: Float) {
        var connection = RaspberryPiService.instance.connection
        do {
            Log.d(TAG, "RPi pwm pin=" + pinInterpretation + ", " + percentageInterpretation + "%, " + frequencyInterpretation + "Hz")
            connection.setPWM(pinInterpretation, frequencyInterpretation, percentageInterpretation)
        } catch let e {
            Log.e(TAG, "RPi: exception during setPwm: " + e)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setPinNumberFormula(_ pinNumberFormula: Formula) {
        self.pinNumberFormula = pinNumberFormula
    }

    public func setPwmFrequencyFormula(_ pwmFrequencyFormula: Formula) {
        self.pwmFrequencyFormula = pwmFrequencyFormula
    }

    public func setPwmPercentageFormula(_ pwmPercentageFormula: Formula) {
        self.pwmPercentageFormula = pwmPercentageFormula
    }
}
