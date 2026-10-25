import Foundation

open class ShowTextColorSizeAlignmentAction: TemporalAction {
    public static let TAG: String = String(describing: ShowTextColorSizeAlignmentAction.self)
    var xPosition: Formula!
    var yPosition: Formula!
    var relativeTextSize: Formula!
    var color: Formula!
    var variableToShow: UserVariable!
    var scope: Scope!
    var alignment: Int = 0
    var actor: ShowTextActor!
    var androidStringProvider: StringProvider! // Змінено на Swift-еквівалент (або твій тип)

    public required init() { super.init() }

    open override func begin() {
        do {
            let xPositionVal: Int = try self.xPosition.interpretInteger(scope)
            let yPositionVal: Int = try self.yPosition.interpretInteger(scope)
            let relativeTextSizeVal: Float = try self.relativeTextSize.interpretFloat(scope) / 100
            let colorVal: String = try self.color.interpretString(scope)
            
            if let stageListener = StageManager.shared.stageListener {
                let stageActors = stageListener.stage.actors
                let dummyActor = ShowTextActor(UserVariable("dummyActor"), 0, 0, relativeTextSizeVal, colorVal, scope.sprite, alignment, androidStringProvider)
                
                for existingActor in stageActors {
                    // У Swift перевірка типу робиться через `is` та `as?`
                    if type(of: existingActor) == type(of: dummyActor) {
                        if let showTextActor = existingActor as? ShowTextActor {
                            if showTextActor.variableNameToCompare == variableToShow.name && showTextActor.sprite == scope.sprite {
                                existingActor.remove()
                            }
                        }
                    }
                }
                actor = ShowTextActor(variableToShow, xPositionVal, yPositionVal, relativeTextSizeVal, colorVal, scope.sprite, alignment, androidStringProvider)
            }
            
            if relativeTextSizeVal <= 0.0 {
                variableToShow.setVisible(false)
            } else {
                StageManager.shared.stageListener?.addActor(actor)
                variableToShow.setVisible(true)
            }
        } catch let e {
            Log.d(ShowTextColorSizeAlignmentAction.TAG, "InterpretationException: \(e)")
        }
    }

    open override func update(_ percent: Float) {
        do {
            let xPositionVal: Int = try self.xPosition.interpretInteger(scope)
            let yPositionVal: Int = try self.yPosition.interpretInteger(scope)
            if let actor = actor {
                actor.setPositionX(Float(xPositionVal))
                actor.setPositionY(Float(yPositionVal))
            }
        } catch {
            Log.d(ShowTextColorSizeAlignmentAction.TAG, "InterpretationException")
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

    public func setAndroidStringProvider(_ androidStringProvider: StringProvider) {
        self.androidStringProvider = androidStringProvider
    }
}
