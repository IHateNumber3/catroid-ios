import Foundation

open class ThinkSayBubbleAction: TemporalAction {
    public static let TAG: String = String(describing: ThinkSayBubbleAction.self)
    var androidStringProvider: StringProvider!
    var scope: Scope!
    var text: Formula!
    var type: Int = 0

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        let showBubbleActor: ShowBubbleActor?
        do {
            showBubbleActor = try createBubbleActor(androidStringProvider)
        } catch let e {
            Log.d(ThinkSayBubbleAction.TAG, "Failed to create Bubble Actor", e)
            return
        }
        
        if let stageListener = StageManager.shared.stageListener {
            if stageListener.getBubbleActorForSprite(scope.sprite) != nil {
                stageListener.removeBubbleActorForSprite(scope.sprite)
            }
            if let bubbleActor = showBubbleActor {
                stageListener.setBubbleActorForSprite(scope.sprite, bubbleActor)
            }
        }
    }

    public func createBubbleActor(_ stringProvider: StringProvider) throws -> ShowBubbleActor? {
        let textToDisplay: String = text == nil ? "" : try text.getUserFriendlyString(stringProvider, scope)
        if textToDisplay.isEmpty {
            return nil
        }
        return ShowBubbleActor(textToDisplay, scope.sprite, type)
    }

    public func setAndroidStringProvider(_ androidStringProvider: StringProvider) {
        self.androidStringProvider = androidStringProvider
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setText(_ text: Formula) {
        self.text = text
    }

    public func setType(_ type: Int) {
        self.type = type
    }
}
