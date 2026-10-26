import Foundation

open class ResetTimerAction: TemporalAction {
    public override init() { super.init() }

    open override func update(_ percent: Float) {
        SensorHandler.timerReferenceValue = SystemClock.uptimeMillis()
    }
}
