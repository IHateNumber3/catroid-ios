import Foundation

open class ClearBackgroundAction: TemporalAction {
    public override init() { super.init() }

    open override func update(_ delta: Float) {
        StageActivity.stageListener.clearBackground()
    }
}
