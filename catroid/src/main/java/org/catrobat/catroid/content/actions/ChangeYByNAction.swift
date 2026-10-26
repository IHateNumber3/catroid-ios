import Foundation

open class ChangeYByNAction: TemporalAction {
    var scope: Scope!
    var yMovement: Formula!

    public override init() { super.init() }

    open override func update(_ arg0: Float) {
        do {
            var newY: Float = try yMovement == nil ? Float(0) : yMovement.interpretFloat(scope)
            scope.sprite.look.changeYInUserInterfaceDimensionUnit(newY)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setyMovement(_ yMovement: Formula) {
        self.yMovement = yMovement
    }
}
