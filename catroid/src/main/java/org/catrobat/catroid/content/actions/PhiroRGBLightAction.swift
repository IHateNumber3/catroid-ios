import Foundation

open class PhiroRGBLightAction: TemporalAction {
    public static let TAG: String = PhiroRGBLightAction.class.getSimpleName()
    public static let MIN_VALUE: Int = 0
    public static let MAX_VALUE: Int = 255
    var eyeEnum: Eye!
    var red: Formula!
    var green: Formula!
    var blue: Formula!
    var scope: Scope!
    var btService: BluetoothDeviceService = ServiceProvider.getService(CatroidService.bluetoothDeviceService)

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        var redValue: Int = updateFormulaValue(red)
        var greenValue: Int = updateFormulaValue(green)
        var blueValue: Int = updateFormulaValue(blue)
        var phiro = btService.getDevice(BluetoothDevice.phiro)
        if eyeEnum.equals(Eye.left) {
            phiro.setLeftRGBLightColor(redValue, greenValue, blueValue)
        } else if eyeEnum.equals(Eye.right) {
            phiro.setRightRGBLightColor(redValue, greenValue, blueValue)
        } else if eyeEnum.equals(Eye.both) {
            phiro.setLeftRGBLightColor(redValue, greenValue, blueValue)
            phiro.setRightRGBLightColor(redValue, greenValue, blueValue)
        } else {
            Log.d(TAG, "Error: EyeEnum:" + eyeEnum)
        }
    }

    private func updateFormulaValue(_ rgbFormula: Formula) -> Int {
        var rgbValue: Int
        do {
            try rgbValue = rgbFormula.interpretInteger(scope)
        } catch let interpretationException {
            rgbValue = 0
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
        if rgbValue < MIN_VALUE {
            rgbValue = MIN_VALUE
        } else if rgbValue > MAX_VALUE {
            rgbValue = MAX_VALUE
        }
        return rgbValue
    }

    public func setEyeEnum(_ eyeEnum: Eye) {
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
