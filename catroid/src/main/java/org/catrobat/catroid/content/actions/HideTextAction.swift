import Foundation

open class HideTextAction: TemporalAction {
    var variableToHide: UserVariable!
    var sprite: Sprite!
    var androidStringProvider: AndroidStringProvider!

    public required init() { super.init() }

    open override func begin() {
        if StageActivity.stageListener != nil {
            Array<Actor> stageActors = StageActivity.stageListener.stage.actors
            var dummyActor = ShowTextActor(UserVariable("dummyActor"), 0, 0, 1.0, nil, sprite, androidStringProvider)
            for actor in stageActors {
                if actor.getClass().equals(dummyActor.getClass()) {
                    var showTextActor = (ShowTextActor) actor
                    if showTextActor.variableNameToCompare.equals(variableToHide.name) && showTextActor.sprite.equals(sprite) {
                        actor.remove()
                    }
                }
            }
        }
        variableToHide.setVisible(false)
    }

    open override func update(_ percent: Float) {
    }

    public func setVariableToHide(_ userVariable: UserVariable) {
        self.variableToHide = userVariable
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }

    public func setAndroidStringProvider(_ androidStringProvider: AndroidStringProvider) {
        self.androidStringProvider = androidStringProvider
    }
}
