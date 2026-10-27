import Foundation
import UIKit

open class SetThreadColorAction: TemporalAction {
    var scope: Scope!
    var color: Formula!
    var sprite: Sprite!

    public required init() { super.init() }

    open override func update(_ delta: Float) {
        do {
            let raw = try color?.interpretString(scope) ?? "#ff0000"
            let hex = raw.trimmingCharacters(in: CharacterSet(charactersIn: "#")).replacingOccurrences(of: "0x", with: "")
            guard hex.count >= 6, let value = UInt64(String(hex.suffix(6)), radix: 16) else { return }
            let red = CGFloat((value >> 16) & 0xFF) / 255.0
            let green = CGFloat((value >> 8) & 0xFF) / 255.0
            let blue = CGFloat(value & 0xFF) / 255.0
            sprite.embroideryThreadColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        } catch {
            Log.d(String(describing: type(of: self)), "Formula interpretation for this specific Brick failed.", error)
        }
    }

    public func setScope(_ scope: Scope) { self.scope = scope }
    public func setSprite(_ sprite: Sprite) { self.sprite = sprite }
    public func setColor(_ color: Formula) { self.color = color }
}
