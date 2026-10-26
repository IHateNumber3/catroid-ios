import Foundation

open class SetPenColorAction: TemporalAction {
    var scope: Scope!
    var red: Formula!
    var green: Formula!
    var blue: Formula!

    public override init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            var newRed: Int = try red == nil ? 0 : red.interpretInteger(scope)
            var newGreen: Int = try green == nil ? 0 : green.interpretInteger(scope)
            var newBlue: Int = try blue == nil ? 0 : blue.interpretInteger(scope)
            scope.sprite.penConfiguration.setPenColor(Color.penColor(fromARGB: Color.argb(0xFF, newRed, newGreen, newBlue)))
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
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
}
