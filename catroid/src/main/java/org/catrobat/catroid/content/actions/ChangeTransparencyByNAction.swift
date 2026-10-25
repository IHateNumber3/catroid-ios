import Foundation

open class ChangeTransparencyByNAction: TemporalAction {
    var scope: Scope!
    var changeTransparency: Formula!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            var newChangeTransparency: Float = try changeTransparency == nil ? Float(0) : changeTransparency .interpretFloat(scope)
            scope.sprite.look.changeTransparencyInUserInterfaceDimensionUnit(newChangeTransparency)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setTransparency(_ value: Formula) {
        self.changeTransparency = value
    }
}
