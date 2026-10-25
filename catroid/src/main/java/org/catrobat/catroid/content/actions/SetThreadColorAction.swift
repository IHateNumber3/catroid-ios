import Foundation

open class SetThreadColorAction: TemporalAction {
    var scope: Scope!
    var color: Formula!
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            var colorStringInterpretation: String = "0xff0000"
            if color != nil {
                try colorStringInterpretation = color.interpretString(scope)
            }
            var red: String = "0x" + colorStringInterpretation.substring(1, 3)
            var green: String = "0x" + colorStringInterpretation.substring(3, 5)
            var blue: String = "0x" + colorStringInterpretation.substring(5, 7)
            var redInt: Int = Integer.decode(red)
            var greenInt: Int = Integer.decode(green)
            var blueInt: Int = Integer.decode(blue)
            var colorInterpretation = Color()
            Color.argb8888ToColor(colorInterpretation, android.graphics.Color.argb(0xFF, redInt, greenInt, blueInt))
            sprite.setEmbroideryThreadColor(colorInterpretation)
        } catch let exception {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", exception)
        }
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setSprite(_ sprite: Sprite) {
        self.sprite = sprite
    }

    public func setColor(_ color: Formula) {
        self.color = color
    }
}
