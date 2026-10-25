import SpriteKit
import UIKit

public class Passepartout: SKNode {
    
    private var virtualScreenWidth: CGFloat
    private var virtualScreenHeight: CGFloat
    
    private var passepartoutHeight: CGFloat = 0.0
    private var passepartoutWidth: CGFloat = 0.0
    
    private var leftRightNode: SKShapeNode?
    private var topBottomNode: SKShapeNode?
    
    public init(
        screenWidth: CGFloat,
        screenHeight: CGFloat,
        screenViewPortWidth: CGFloat,
        screenViewPortHeight: CGFloat,
        virtualScreenWidth: CGFloat,
        virtualScreenHeight: CGFloat
    ) {
        self.virtualScreenWidth = virtualScreenWidth
        self.virtualScreenHeight = virtualScreenHeight
        
        super.init()
        
        // Расчет размеров паспарту (аналогично Java-реализации)
        if screenViewPortHeight > 0, screenViewPortWidth > 0 {
            self.passepartoutHeight = ((screenHeight / (screenViewPortHeight / virtualScreenHeight)) - virtualScreenHeight) / 2.0
            self.passepartoutWidth = ((screenWidth / (screenViewPortWidth / virtualScreenWidth)) - virtualScreenWidth) / 2.0
        }
        
        setupPassepartoutNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPassepartoutNodes() {
        // Создание черных полос для обрамления с помощью SKShapeNode
        let blackColor = UIColor.black
        
        if passepartoutWidth != 0.0 {
            // Боковые полосы
            let width = abs(passepartoutWidth)
            let height = virtualScreenHeight
            
            let leftRect = CGRect(x: -virtualScreenWidth / 2.0 - width, y: -height / 2.0, width: width, height: height)
            let rightRect = CGRect(x: virtualScreenWidth / 2.0, y: -height / 2.0, width: width, height: height)
            
            let path = CGPath(rect: leftRect, transform: nil)
            let rightPath = CGPath(rect: rightRect, transform: nil)
            
            let combinedPath = CGMutablePath()
            combinedPath.addPath(path)
            combinedPath.addPath(rightPath)
            
            let node = SKShapeNode(path: combinedPath)
            node.fillColor = blackColor
            node.strokeColor = .clear
            addChild(node)
        }
        
        if passepartoutHeight != 0.0 {
            // Верхняя и нижняя полосы
            let width = virtualScreenWidth
            let height = abs(passepartoutHeight)
            
            let bottomRect = CGRect(x: -width / 2.0, y: -virtualScreenHeight / 2.0 - height, width: width, height: height)
            let topRect = CGRect(x: -width / 2.0, y: virtualScreenHeight / 2.0, width: width, height: height)
            
            let combinedPath = CGMutablePath()
            let path1 = CGPath(rect: bottomRect, transform: nil)
            let path2 = CGPath(rect: topRect, transform: nil)
            combinedPath.addPath(path1)
            combinedPath.addPath(path2)
            
            let node = SKShapeNode(path: combinedPath)
            node.fillColor = blackColor
            node.strokeColor = .clear
            addChild(node)
        }
    }
    
    /// Проверка нажатия за пределами виртуального экрана (аналог hit в LibGDX)
    public func containsPoint(at point: CGPoint) -> Bool {
        let halfWidth = virtualScreenWidth / 2.0
        let halfHeight = virtualScreenHeight / 2.0
        
        if point.x < -halfWidth || point.x > halfWidth || point.y < -halfHeight || point.y > halfHeight {
            return true
        }
        return false
    }
}
