import Foundation

open class ThinkSayBubbleAction: TemporalAction {
    public static let TAG: String = String(describing: ThinkSayBubbleAction.self)
    var androidStringProvider: AndroidStringProvider!
    var scope: Scope!
    var text: Formula!
    var type: Int = 0

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        ShowBubbleActor showBubbleActor
        do {
            showBubbleActor = createBubbleActor(androidStringProvider)
        } catch let e {
            Log.d(ThinkSayBubbleAction.TAG, "Failed to create Bubble Actor", e)
            return
        }
        if StageActivity.stageListener.getBubbleActorForSprite(scope.sprite) != nil {
            StageActivity.stageListener.removeBubbleActorForSprite(scope.sprite)
        }
        if showBubbleActor != nil {
            StageActivity.stageListener.setBubbleActorForSprite(scope.sprite, showBubbleActor)
        }
    }

    public func createBubbleActor(_ stringProvider: AndroidStringProvider) -> ShowBubbleActor {
        var textToDisplay: String = text == nil ? "" : text.getUserFriendlyString(stringProvider, scope)
        if textToDisplay.isEmpty() {
            return nil
        }
        return ShowBubbleActor(textToDisplay, scope.sprite, type)
    }

    public func setAndroidStringProvider(_ androidStringProvider: AndroidStringProvider) {
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
