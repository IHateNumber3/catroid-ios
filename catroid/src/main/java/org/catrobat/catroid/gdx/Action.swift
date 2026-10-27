import Foundation

/// Минимальная замена com.badlogic.gdx.scenes.scene2d.Action.
/// Диспетчер (StageListener / Look) вызывает act(delta) каждый кадр.
open class Action {
    public weak var actor: Actor? { didSet { actorDidChange() } }
    public init() {}

    /// Аналог переопределения setActor() в scene2d
    open func actorDidChange() {}

    /// Compatibility hooks used by actions ported from the Android implementation.
    open func begin() {}
    open func end() {}

    public func setActor(_ actor: Actor?) { self.actor = actor }

    /// true — действие завершено
    open func act(_ delta: Float) -> Bool { return true }
    open func restart() {}
    open func reset() { actor = nil; restart() }
}

/// Замена ParallelAction/SequenceAction/Actions.sequence
open class SequenceAction: Action {
    public private(set) var actions: [Action] = []
    private var index = 0

    public override init() { super.init() }

    public init(actions initial: [Action]) {
        super.init()
        initial.forEach { addAction($0) }
    }

    public func addAction(_ action: Action) {
        actions.append(action)
        action.actor = actor
    }

    public func getActions() -> [Action] { return actions }

    public override func act(_ delta: Float) -> Bool {
        if index >= actions.count { return true }
        let current = actions[index]
        if current.act(delta) {
            if actor == nil { return true } // как в libGDX: действие снято со сцены
            index += 1
            if index >= actions.count { return true }
        }
        return false
    }

    public override func actorDidChange() {
        actions.forEach { $0.actor = actor }
    }

    public override func restart() {
        index = 0
        actions.forEach { $0.restart() }
    }

    public override func reset() {
        actions.removeAll()
        index = 0
        super.reset()
    }
}
