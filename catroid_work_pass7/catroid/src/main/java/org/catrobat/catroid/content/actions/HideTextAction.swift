import Foundation

open class HideTextAction: TemporalAction {
    var variableToHide: UserVariable!
    var sprite: Sprite!
    var androidStringProvider: AndroidStringProvider!

    public required init() { super.init() }

    open override func begin() {
        if let variable = variableToHide, let sprite = sprite {
            let scene = StageListener.shared.stage
            for node in scene.textNodes {
                guard let textActor = node as? ShowTextActor else { continue }
                if textActor.targetVariableNameToCompare == variable.name && textActor.associatedSprite === sprite {
                    scene.removeTextNode(textActor)
                }
            }
            variable.setVisible(false)
        }
    }

    open override func update(_ percent: Float) { }
    public func setVariableToHide(_ variable: UserVariable) { variableToHide = variable }
    public func setSprite(_ sprite: Sprite) { self.sprite = sprite }
    public func setAndroidStringProvider(_ provider: AndroidStringProvider) { androidStringProvider = provider }
}
