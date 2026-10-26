import Foundation

open class ThinkSayBubbleAction: TemporalAction {
    public static let TAG = String(describing: ThinkSayBubbleAction.self)
    var androidStringProvider: AndroidStringProvider!
    var scope: Scope!
    var text: Formula!
    var type: Int = 0

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        guard let scope = scope else { return }
        let bubble: ShowBubbleActor
        do {
            bubble = try createBubbleActor(androidStringProvider)
        } catch {
            Log.d(Self.TAG, "Failed to create Bubble Actor", error)
            return
        }
        if StageListener.shared.getBubbleActorForSprite(scope.sprite) != nil {
            StageListener.shared.removeBubbleActorForSprite(scope.sprite)
        }
        StageListener.shared.setBubbleActorForSprite(scope.sprite, bubble)
    }

    public func createBubbleActor(_ stringProvider: AndroidStringProvider) throws -> ShowBubbleActor {
        let textToDisplay = text == nil ? "" : text.getUserFriendlyString(stringProvider, scope)
        guard !textToDisplay.isEmpty else {
            throw NSError(domain: "ThinkSayBubbleAction", code: 1, userInfo: [NSLocalizedDescriptionKey: "Bubble text is empty"])
        }
        return ShowBubbleActor(textToDisplay, scope.sprite, type)
    }

    public func setAndroidStringProvider(_ provider: AndroidStringProvider) { androidStringProvider = provider }
    public func setScope(_ scope: Scope) { self.scope = scope }
    public func setText(_ text: Formula) { self.text = text }
    public func setType(_ type: Int) { self.type = type }
}
