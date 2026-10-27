import SpriteKit
import UIKit

public class EmbroideryActor: SKNode {
    
    private var stitchSize: CGFloat
    private var patternManager: EmbroideryPatternManager // Заглушка типа менеджера вышивки
    
    private var embroideryShapeNode: SKShapeNode!
    
    public init(screenRatio: CGFloat, patternManager: EmbroideryPatternManager) {
        // BrickValues.STITCH_SIZE по умолчанию, умноженный на коэффициент экрана
        self.stitchSize = 2.0 * screenRatio 
        self.patternManager = patternManager
        
        super.init()
        
        embroideryShapeNode = SKShapeNode()
        addChild(embroideryShapeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Отрисовка стежков вышивки (аналог метода draw)
    public func updateEmbroideryDrawing() {
        let stitchPoints = patternManager.embroideryPatternList
        guard stitchPoints.count >= 2 else {
            embroideryShapeNode.path = nil
            return
        }
        
        let path = UIBezierPath()
        let circlePath = UIBezierPath()
        
        var iterator = stitchPoints.makeIterator()
        guard var stitchPoint = iterator.next() else { return }
        
        // Рисуем первую точку (круг)
        let firstPointCoord = CGPoint(x: CGFloat(stitchPoint.x), y: CGFloat(stitchPoint.y))
        addCircle(to: circlePath, at: firstPointCoord, radius: stitchSize)
        
        var colorChange = false
        
        while let nextPoint = iterator.next() {
            let previousPointCoord = firstPointCoord
            let nextPointCoord = CGPoint(x: CGFloat(nextPoint.x), y: CGFloat(nextPoint.y))
            
            colorChange = colorChange || nextPoint.isColorChangePoint
            
            if !colorChange {
                // Рисуем линию стежка
                path.move(to: previousPointCoord)
                path.addLine(to: nextPointCoord)
            }
            
            if nextPoint.isConnectingPoint {
                addCircle(to: circlePath, at: nextPointCoord, radius: stitchSize)
                colorChange = false
            }
            
            stitchPoint = nextPoint
        }
        
        // Применяем пути к узлу SpriteKit
        embroideryShapeNode.path = path.cgPath
        embroideryShapeNode.strokeColor = .magenta // Или цвет конкретного стежка
        embroideryShapeNode.lineWidth = stitchSize
    }
    
    private func addCircle(to path: UIBezierPath, at point: CGPoint, radius: CGFloat) {
        let rect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        path.append(UIBezierPath(ovalIn: rect))
    }
    
    public func dispose() {
        embroideryShapeNode.path = nil
        removeAllChildren()
    }
}
