import Foundation

open class PhiroRGBLightAction: TemporalAction {
    public static let TAG: String = String(describing: PhiroRGBLightAction.self)
    public static let MIN_VALUE: Int = 0
    public static let MAX_VALUE: Int = 255
    var eyeEnum: Any!
    var red: Formula!
    var green: Formula!
    var blue: Formula!
    var scope: Scope!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
    }

    private func updateFormulaValue(_ rgbFormula: Formula) -> Int {
        var rgbValue: Int
        do {
            try rgbValue = rgbFormula.interpretInteger(scope)
        } catch let interpretationException {
            rgbValue = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        if rgbValue < PhiroRGBLightAction.MIN_VALUE {
            rgbValue = PhiroRGBLightAction.MIN_VALUE
        } else if rgbValue > PhiroRGBLightAction.MAX_VALUE {
            rgbValue = PhiroRGBLightAction.MAX_VALUE
        }
        return rgbValue
    }

    public func setEyeEnum(_ eyeEnum: Any) {
        self.eyeEnum = eyeEnum
    }

    public func setRed(_ red: Formula) {
        self.red = red
    }

    public func setGreen(_ green: Formula) {
        self.green = green
    }

    public func setBlue(_ blue: Formula) {
        self.blue = blue
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
