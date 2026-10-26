import Foundation

open class SetYAction: TemporalAction {
    var scope: Scope!
    var yPosition: Formula!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            var newY: Float = try yPosition == nil ? Float(0) : yPosition.interpretFloat(scope)
            scope.sprite.look.setYInUserInterfaceDimensionUnit(newY)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setY(_ y: Formula) {
        self.yPosition = y
    }
}
