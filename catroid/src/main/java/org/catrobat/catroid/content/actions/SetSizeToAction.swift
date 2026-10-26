import Foundation

open class SetSizeToAction: TemporalAction {
    var scope: Scope!
    var size: Formula!

    public override init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            var newSize: Float = try size == nil ? Float(0) : size.interpretFloat(scope)
            scope.sprite.look.setSizeInUserInterfaceDimensionUnit(newSize)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setSize(_ size: Formula) {
        self.size = size
    }
}
