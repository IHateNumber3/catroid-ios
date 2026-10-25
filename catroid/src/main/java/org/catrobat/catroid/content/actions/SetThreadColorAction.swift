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
            
            // Безпечне очищення префіксу та витягування RGB-компонентів у Swift
            let hexString = colorStringInterpretation.hasPrefix("0x") ? 
                String(colorStringInterpretation.dropFirst(2)) : 
                colorStringInterpretation
            
            let redStr = hexString.prefix(2)
            let greenStr = hexString.dropFirst(2).prefix(2)
            let blueStr = hexString.dropFirst(4).prefix(2)
            
            let redInt = Int(redStr, radix: 16) ?? 0
            let greenInt = Int(greenStr, radix: 16) ?? 0
            let blueInt = Int(blueStr, radix: 16) ?? 0
            
            // Створення кольору через Swift-ініціалізатор
            let colorInterpretation = Color(
                red: Float(redInt) / 255.0,
                green: Float(greenInt) / 255.0,
                blue: Float(blueInt) / 255.0,
                alpha: 1.0
            )
            
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
