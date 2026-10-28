import Foundation

open class GlideToAction: TemporalAction {
    private var endX: Formula?
    private var endY: Formula?
    public var duration: Formula?
    var scope: Scope!
    private var startX: Float = 0
    private var startY: Float = 0
    private var targetX: Float = 0
    private var targetY: Float = 0

    public required init() { super.init() }

    open override func begin() {
        guard let scope = scope else { return }
        startX = scope.sprite.look.xInUserInterfaceDimensionUnit
        startY = scope.sprite.look.yInUserInterfaceDimensionUnit
        do {
            targetX = try endX?.interpretFloat(scope) ?? startX
            targetY = try endY?.interpretFloat(scope) ?? startY
            let d = try duration?.interpretFloat(scope) ?? 0
            setDuration(max(0, d))
        } catch {
            targetX = startX; targetY = startY; setDuration(0)
        }
        let d = getDuration()
        if d > 0 {
            scope.sprite.glidingVelocityX = (targetX - startX) / d
            scope.sprite.glidingVelocityY = (targetY - startY) / d
        }
        scope.sprite.isGliding = true
    }

    open override func update(_ percent: Float) {
        guard let scope = scope else { return }
        scope.sprite.look.setPositionInUserInterfaceDimensionUnit(startX + (targetX - startX) * percent, startY + (targetY - startY) * percent)
    }

    open override func end() {
        scope?.sprite.isGliding = false
        scope?.sprite.look.setPositionInUserInterfaceDimensionUnit(targetX, targetY)
    }

    open override func restart() { super.restart() }
    public func setScope(_ scope: Scope) { self.scope = scope }
    public func setPosition(_ x: Formula, _ y: Formula) { endX = x; endY = y }
    public func setInterpolation(_ interpolation: Interpolation?) { self.interpolation = interpolation }
    public func setDurationFormula(_ duration: Formula) { self.duration = duration }
    public func setDuration(_ duration: Formula) { self.duration = duration }
}
