import Foundation

public final class ThreadScheduler {

    public enum SchedulerState: Int {
        case running = 0
        case suspended = 1
    }
    public static let running = SchedulerState.running
    public static let suspended = SchedulerState.suspended

    private var startQueue: [ScriptSequenceAction] = []
    private var stopQueue: [Action] = []
    private weak var actor: Actor?
    private var state: SchedulerState = .running

    public init(actor: Actor) {
        self.actor = actor
    }

    public func tick(_ delta: Float) {
        guard let actor = actor else { return }
        startThreadsInStartQueue(actor)
        runThreadsForOneTick(actor, delta)
        stopThreadsInStopQueue(actor)
    }

    private func startThreadsInStartQueue(_ actor: Actor) {
        for thread in startQueue {
            thread.restart()
            actor.addAction(thread)
        }
        startQueue.removeAll()
    }

    private func runThreadsForOneTick(_ actor: Actor, _ delta: Float) {
        var i = 0
        // индекс, а не for-in: действия могут менять actor.actions во время act()
        while i < actor.actions.count {
            let action = actor.actions[i]
            if state == .running && action.act(delta) {
                stopQueue.append(action)
            }
            i += 1
        }
    }

    private func stopThreadsInStopQueue(_ actor: Actor) {
        actor.actions.removeAll { a in stopQueue.contains { $0 === a } }
        for action in stopQueue {
            (action as? ScriptSequenceActionWithWaiter)?.notifyWaiter()
        }
        stopQueue.removeAll()
    }

    public func startThread(_ sequenceAction: ScriptSequenceAction) {
        removeThreadsWithEqualScriptFromStartQueue(sequenceAction)
        startQueue.append(sequenceAction)
    }

    private func removeThreadsWithEqualScriptFromStartQueue(_ sequenceAction: ScriptSequenceAction) {
        startQueue.removeAll { action in
            if action.script === sequenceAction.script {
                (action as? ScriptSequenceActionWithWaiter)?.notifyWaiter()
                return true
            }
            return false
        }
    }

    public func stopThreadsWithScript(_ script: Script) {
        guard let actor = actor else { return }
        for action in actor.actions {
            if let s = action as? ScriptSequenceAction, s.script === script {
                stopQueue.append(action)
            }
        }
    }

    public func stopThreads(_ actions: [Action]) {
        stopQueue.append(contentsOf: actions)
    }

    public func haveAllThreadsFinished() -> Bool {
        return startQueue.count + (actor?.actions.count ?? 0) == 0
    }

    public func setState(_ s: SchedulerState) {
        state = s
    }
}
