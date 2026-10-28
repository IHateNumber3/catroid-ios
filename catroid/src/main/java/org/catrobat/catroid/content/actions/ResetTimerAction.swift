import Foundation

open class ResetTimerAction: TemporalAction {
    public required init() { super.init() }

    open override func update(_ percent: Float) {
        SensorHandler.timerReferenceValue = ProcessInfo.processInfo.systemUptime * 1000.0
    }
}
