import Foundation

open class SetColorAction: TemporalAction {
    public static let TAG: String = SetColorAction.class.getSimpleName()
    var scope: Scope!
    var color: Formula!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            var eightBitColor: Float = try color == nil ? 0 : color.interpretFloat(scope)
            scope.sprite.look.setColorInUserInterfaceDimensionUnit(eightBitColor)
        } catch let interpretationException {
            Log.d(TAG, "Formula interpretation for this specific Brick failed.", interpretationException)
        }
    }

    public func setColor(_ color: Formula) {
        self.color = color
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
