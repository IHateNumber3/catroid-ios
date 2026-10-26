import Foundation
import SpriteKit

/// Текст на сцене (SetTextAction / ShowText). Рисуется SKLabelNode.
public final class TextActor: Actor {
    public private(set) var text: String
    public private(set) var posX: Int
    public private(set) var posY: Int
    public let node = SKLabelNode()

    public init(_ text: String, _ posX: Int, _ posY: Int) {
        self.text = text; self.posX = posX; self.posY = posY
        super.init()
        node.fontColor = .red
        node.fontName = "Helvetica"
        node.horizontalAlignmentMode = .left
        refresh()
    }

    public func setText(_ t: String) { text = t; refresh() }
    public func setPosX(_ x: Int) { posX = x; refresh() }
    public func setPosY(_ y: Int) { posY = y; refresh() }

    private func refresh() {
        node.text = text
        node.position = CGPoint(x: posX, y: posY)
    }
}

/// Заготовки под порт StageListener (облачка речи, перо, вышивка)
public final class ShowBubbleActor {}

public final class PenActor {
    public init() {}
    public func stampToFrameBuffer() {}
}
