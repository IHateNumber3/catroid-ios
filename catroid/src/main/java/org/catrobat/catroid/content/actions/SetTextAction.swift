import Foundation

open class SetTextAction: TemporalAction {
    var endX: Formula!
    var endY: Formula!
    var text: Formula!
    var scope: Scope!
    var textActor: TextActor!

    public required init() { super.init() }

    open override func begin() {
        do {
            var string: String = try text.interpretString(scope)
            var posX: Int = try endX.interpretInteger(scope)
            var posY: Int = try endY.interpretInteger(scope)
            textActor = TextActor(text: string, posX: posX, posY: posY)
            StageListener.shared.addActor(textActor)
        } catch let exception {
            Log.e(String(describing: type(of: self)), String(describing: exception))
        }
    }

    open override func update(_ percent: Float) {
        do {
            var str: String = try text.interpretString(scope)
            var posX: Int = try endX.interpretInteger(scope)
            var posY: Int = try endY.interpretInteger(scope)
            textActor.setText(str)
            textActor.setPosX(posX)
            textActor.setPosY(posY)
        } catch let exception {
            Log.e(String(describing: type(of: self)), String(describing: exception))
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
