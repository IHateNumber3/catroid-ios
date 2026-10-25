import Foundation

open class ShowTextColorSizeAlignmentAction: TemporalAction {
    public static let TAG: String = ShowTextColorSizeAlignmentAction.class.getSimpleName()
    var xPosition: Formula!
    var yPosition: Formula!
    var relativeTextSize: Formula!
    var color: Formula!
    var variableToShow: UserVariable!
    var scope: Scope!
    var alignment: Int = 0
    var actor: ShowTextActor!
    var androidStringProvider: AndroidStringProvider!

    public required init() { super.init() }

    open override func begin() {
        do {
            var xPosition: Int = try self.xPosition.interpretInteger(scope)
            var yPosition: Int = try self.yPosition.interpretInteger(scope)
            var relativeTextSize: Float = try self.relativeTextSize.interpretFloat(scope) / 100
            var color: String = try self.color.interpretString(scope)
            if StageActivity.stageListener != nil {
                Array<Actor> stageActors = StageActivity.stageListener.stage.actors
                var dummyActor = ShowTextActor(UserVariable("dummyActor"), 0, 0, relativeTextSize, color, scope.sprite, alignment, androidStringProvider)
                for actor in stageActors {
                    if actor.getClass().equals(dummyActor.getClass()) {
                        var showTextActor = (ShowTextActor) actor
                        if showTextActor.variableNameToCompare.equals(variableToShow.name) && showTextActor.sprite.equals(scope.sprite) {
                            actor.remove()
                        }
                    }
                }
                actor = ShowTextActor(variableToShow, xPosition, yPosition, relativeTextSize, color, scope.sprite, alignment, androidStringProvider)
            }
            if relativeTextSize <= 0.0 {
                variableToShow.setVisible(false)
            } else {
                StageActivity.stageListener.addActor(actor)
                variableToShow.setVisible(true)
            }
        } catch let e {
            Log.d(TAG, "InterpretationException: " + e)
        }
    }

    open override func update(_ percent: Float) {
        do {
            var xPosition: Int = try self.xPosition.interpretInteger(scope)
            var yPosition: Int = try self.yPosition.interpretInteger(scope)
            if actor != nil {
                actor.setPositionX(xPosition)
                actor.setPositionY(yPosition)
            }
        } catch let e {
            Log.d(TAG, "InterpretationException")
        }
    }

    public func setPosition(_ xPosition: Formula, _ yPosition: Formula) {
        self.xPosition = xPosition
        self.yPosition = yPosition
    }

    public func setRelativeTextSize(_ relativeTextSize: Formula) {
        self.relativeTextSize = relativeTextSize
    }

    public func setColor(_ color: Formula) {
        self.color = color
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setVariableToShow(_ userVariable: UserVariable) {
        self.variableToShow = userVariable
    }

    public func setAlignment(_ alignment: Int) {
        self.alignment = alignment
    }

    public func setAndroidStringProvider(_ androidStringProvider: AndroidStringProvider) {
        self.androidStringProvider = androidStringProvider
    }
}
