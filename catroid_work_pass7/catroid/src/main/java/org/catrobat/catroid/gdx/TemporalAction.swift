import Foundation

public typealias Interpolation = (Float) -> Float

/// Порт com.badlogic.gdx.scenes.scene2d.actions.TemporalAction
open class TemporalAction: Action {
    private var duration: Float = 0
    private var time: Float = 0
    public var interpolation: Interpolation?
    private var reverse = false
    private var began = false
    private var complete = false

    public required override init() { super.init() }

    public init(duration: Float, interpolation: Interpolation? = nil) {
        self.duration = duration
        self.interpolation = interpolation
        super.init()
    }

    open override func act(_ delta: Float) -> Bool {
        if complete { return true }
        if !began {
            begin()
            began = true
        }
        time += delta
        complete = time >= duration
        var percent: Float
        if complete {
            percent = 1
        } else {
            percent = time / duration
            if let i = interpolation { percent = i(percent) }
        }
        update(reverse ? 1 - percent : percent)
        if complete { end() }
        return complete
    }

    open func begin() {}
    open func end() {}
    open func update(_ percent: Float) {}

    /// Завершает действие досрочно
    public func finish() { time = duration }

    open override func restart() {
        time = 0
        began = false
        complete = false
    }

    open override func reset() {
        super.reset()
        reverse = false
        interpolation = nil
    }

    public func getTime() -> Float { return time }
    public func setTime(_ t: Float) { time = t }
    public func getDuration() -> Float { return duration }
    public func setDuration(_ d: Float) { duration = d }
    public func isReverse() -> Bool { return reverse }
    public func setReverse(_ r: Bool) { reverse = r }
    public func isComplete() -> Bool { return complete }
}
