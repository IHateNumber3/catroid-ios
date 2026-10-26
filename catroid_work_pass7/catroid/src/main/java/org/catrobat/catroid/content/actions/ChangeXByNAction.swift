import Foundation

open class ChangeXByNAction: TemporalAction {
    var scope: Scope!
    var xMovement: Formula!

    public required init() { super.init() }

    open override func update(_ percent: Float) {
        do {
            var newX: Float = try xMovement == nil ? Float(0) : xMovement.interpretFloat(scope)
            scope.sprite.look.changeXInUserInterfaceDimensionUnit(newX)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setxMovement(_ xMovement: Formula) {
        self.xMovement = xMovement
    }
}
