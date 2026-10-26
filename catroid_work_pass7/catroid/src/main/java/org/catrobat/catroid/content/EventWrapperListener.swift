import Foundation

final class EventWrapperListener: EventListener {

    private unowned let look: Look

    init(look: Look) {
        self.look = look
    }

    func handle(_ event: Event) -> Bool {
        guard let wrapper = event as? EventWrapper else { return false }
        handleEvent(wrapper)
        return true
    }

    private func handleEvent(_ event: EventWrapper) {
        guard let sprite = look.sprite else { return }
        for sequenceAction in sprite.idToEventThreadMap[event.eventId] ?? [] {
            if event.eventId is UserDefinedBrickEventId {
                handleUserBrickEvent(sequenceAction, event)
                return // как в Kotlin: non-local return из forEach
            }
            look.stopThreadWithScript(sequenceAction.script)
            if event.addSpriteToWaitList(sprite) {
                look.startThread(ScriptSequenceActionWithWaiter(thread: sequenceAction, event: event, sprite: sprite))
            } else {
                look.startThread(sequenceAction)
            }
        }
    }

    private func handleUserBrickEvent(_ sequenceAction: ScriptSequenceAction, _ event: EventWrapper) {
        guard let sprite = look.sprite else { return }
        let scriptClone = sequenceAction.script.clone() as! UserDefinedScript
        let params = (event.eventId as! UserDefinedBrickEventId).userBrickParameters
        scriptClone.userDefinedBrickInputs = params ?? []
        let sequenceClone = sequenceAction.cloneAndChangeScript(scriptClone)
        sequenceClone.script.run(sprite: sprite, sequence: sequenceClone)
        event.addSpriteToWaitList(sprite)
        look.startThread(ScriptSequenceActionWithWaiter(thread: sequenceClone, event: event, sprite: sprite))
    }
}
