import Foundation

open class SetTransparencyAction: TemporalAction {
    var scope: Scope!
    var transparency: Formula!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        do {
            var newTransparency: Float = try transparency == nil ? Float(0) : transparency.interpretFloat(scope)
            scope.sprite.look.setTransparencyInUserInterfaceDimensionUnit(newTransparency)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setTransparency(_ transparency: Formula) {
        self.transparency = transparency
    }
}
