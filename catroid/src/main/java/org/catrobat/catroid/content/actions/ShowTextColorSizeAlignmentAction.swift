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
    var showTextActor: ShowTextActor!
    var androidStringProvider: AndroidStringProvider!

    public required init() { super.init() }

    open override func begin() {
        do {
            let x = try xPosition.interpretInteger(scope)
            let y = try yPosition.interpretInteger(scope)
            let size = try relativeTextSize.interpretFloat(scope) / 100
            let resolvedColor = try color.interpretString(scope)
            let scene = StageListener.shared.stage

            // Remove the previous label for this variable/sprite pair.
            for node in scene.textNodes {
                guard let oldActor = node as? ShowTextActor else { continue }
                if oldActor.variableNameToCompare == variableToShow.name && oldActor.sprite === scope.sprite {
                    scene.removeTextNode(oldActor)
                }
            }

            if size <= 0 {
                variableToShow.setVisible(false)
                actor = nil
                return
            }

            let newActor = ShowTextActor(userVariable: variableToShow,
                                         xPosition: x, yPosition: y,
                                         relativeSize: size, color: resolvedColor,
                                         sprite: scope.sprite, alignment: alignment)
            actor = newActor
            scene.addActor(newActor)
            variableToShow.setVisible(true)
        } catch {
            Log.d(ShowTextColorSizeAlignmentAction.TAG, "Could not show variable text", error)
        }
    }

    open override func update(_ percent: Float) {
        do {
            let x = try xPosition.interpretInteger(scope)
            let y = try yPosition.interpretInteger(scope)
            actor?.setPositionX(x)
            actor?.setPositionY(y)
            actor?.updateVariables()
        } catch {
            Log.d(ShowTextColorSizeAlignmentAction.TAG, "Could not update variable text", error)
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
