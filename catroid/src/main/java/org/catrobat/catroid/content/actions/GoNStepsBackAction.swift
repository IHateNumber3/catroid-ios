import Foundation

open class GoNStepsBackAction: TemporalAction {
    var scope: Scope!
    var steps: Formula!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        var stepsValue: Float
        do {
            try stepsValue = steps == nil ? Float(0) : steps.interpretFloat(scope)
        } catch let interpretationException {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", interpretationException)
            return
        }
        var zPosition: Int = scope.sprite.look.zIndex
        if stepsValue.intValue > 0 && (zPosition - stepsValue.intValue) < Constants.zIndexFirstSprite {
            scope.sprite.look.setZIndex(Constants.zIndexFirstSprite)
        } else if stepsValue.intValue < 0 && (zPosition - stepsValue.intValue) < zPosition {
            toFront(delta)
        } else {
            goNStepsBack(stepsValue.intValue)
        }
    }

    private func toFront(_ delta: Float) {
        var comeToFrontAction = scope.sprite.actionFactory.createComeToFrontAction(scope.sprite)
        comeToFrontAction.act(delta)
    }

    private func goNStepsBack(_ steps: Int) {
        var zPosition: Int = scope.sprite.look.zIndex
        var newSpriteZIndex: Int = Math.max(zPosition - steps, Constants.zIndexFirstSprite)
        scope.sprite.look.setZIndex(newSpriteZIndex)
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setSteps(_ steps: Formula) {
        self.steps = steps
    }
}
