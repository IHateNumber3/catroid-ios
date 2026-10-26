import Foundation

open class SetXAction: TemporalAction {
    var scope: Scope!
    var xPosition: Formula!

    public override init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            var newX: Float = try xPosition == nil ? Float(0) : xPosition.interpretFloat(scope)
            scope.sprite.look.setXInUserInterfaceDimensionUnit(newX)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setX(_ x: Formula) {
        self.xPosition = x
    }
}
