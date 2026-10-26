import Foundation

/// Заменитель android.content.Context для транслированных actions
public final class Context {
    public init() {}
}

public final class ActivityReference {
    private weak var activity: Context?
    public init() {}
    public func set(_ c: Context?) { activity = c }
    public func get() -> Context? { return activity }
}

/// Аналог StageActivity (только статические точки доступа)
public enum StageActivity {
    public static var stageListener: StageListener?
    public static let activeStageActivity = ActivityReference()
}
