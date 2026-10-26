import Foundation

open class SetPenSizeAction: TemporalAction {
    var scope: Scope!
    var penSize: Formula!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            var newSize: Float = try penSize == nil ? Float(0) : penSize.interpretFloat(scope)
            scope.sprite.penConfiguration.setPenSize(newSize)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setPenSize(_ size: Formula) {
        self.penSize = size
    }
}
