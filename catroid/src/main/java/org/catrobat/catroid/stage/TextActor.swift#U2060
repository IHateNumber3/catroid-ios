import SpriteKit
import UIKit

public class TextActor: SKNode {
    
    private var labelNode: SKLabelNode!
    
    public var text: String {
        didSet {
            labelNode.text = text
        }
    }
    
    public var posX: Int {
        didSet {
            updatePosition()
        }
    }
    
    public var posY: Int {
        didSet {
            updatePosition()
        }
    }
    
    public init(text: String, posX: Int, posY: Int) {
        self.text = text
        self.posX = posX
        self.posY = posY
        
        super.init()
        
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        labelNode = SKLabelNode(fontNamed: "Helvetica")
        labelNode.text = text
        labelNode.fontSize = 16.0
        labelNode.fontColor = .red // Аналог цвета шрифта из Android (1.0, 0.0, 0.0, 1.0)
        
        updatePosition()
        addChild(labelNode)
    }
    
    private func updatePosition() {
        // В SpriteKit позиционирование по умолчанию по центру, 
        // а в Catroid координаты могут идти от центра экрана или левого нижнего угла.
        labelNode.position = CGPoint(x: CGFloat(posX), y: CGFloat(posY))
    }
    
    public func setPosX(_ posX: Int) {
        self.posX = posX
    }
    
    public func setPosY(_ posY: Int) {
        self.posY = posY
    }
    
    public func setText(_ text: String) {
        self.text = text
    }
}
