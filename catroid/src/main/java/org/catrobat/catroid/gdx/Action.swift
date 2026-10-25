import Foundation

/// Минимальная замена com.badlogic.gdx.scenes.scene2d.Action.
/// Диспетчер (StageListener / Look) вызывает act(delta) каждый кадр.
open class Action {
    public weak var actor: Actor?
    public init() {}

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

    public init(_ initial: Action...) {
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
