import Foundation

open class SetTextAction: TemporalAction {
    var endX: Formula!
    var endY: Formula!
    var text: Formula!
    var scope: Scope!
    var actor: TextActor!

    public override init() { super.init() }

    open override func begin() {
        do {
            var string: String = try text.interpretString(scope)
            var posX: Int = try endX.interpretInteger(scope)
            var posY: Int = try endY.interpretInteger(scope)
            actor = TextActor(string, posX, posY)
            StageActivity.stageListener.addActor(actor)
        } catch let exception {
            Log.e(String(describing: type(of: self)), Log.getStackTraceString(exception))
        }
    }

    open override func update(_ percent: Float) {
        do {
            var str: String = try text.interpretString(scope)
            var posX: Int = try endX.interpretInteger(scope)
            var posY: Int = try endY.interpretInteger(scope)
            actor.setText(str)
            actor.setPosX(posX)
            actor.setPosY(posY)
        } catch let exception {
            Log.e(String(describing: type(of: self)), Log.getStackTraceString(exception))
        }
    }

    public func setPosition(_ x: Formula, _ y: Formula) {
        endX = x
        endY = y
    }

    public func setText(_ text: Formula) {
        self.text = text
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }
}
