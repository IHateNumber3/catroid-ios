import SpriteKit
import UIKit

public class ShowBubbleActor: SKNode {
    
    private var bubbleValues: [String]
    private var sprite: Sprite
    private var type: Int // Тип (например, SAY_BRICK или THINK)
    
    private var imageLeftNode: SKSpriteNode!
    private var imageRightNode: SKSpriteNode!
    private var currentNode: SKSpriteNode!
    private var drawRight: Bool = true
    
    public init(text: String, sprite: Sprite, type: Int) {
        self.bubbleValues = ShowBubbleActor.formatStringForBubbleBricks(text: text)
        self.sprite = sprite
        self.type = type
        
        super.init()
        
        setupBubbles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBubbles() {
        let leftImage = drawBubbleOnCanvas(lines: bubbleValues, right: false)
        let rightImage = drawBubbleOnCanvas(lines: bubbleValues, right: true)
        
        imageLeftNode = SKSpriteNode(texture: SKTexture(image: leftImage))
        imageRightNode = SKSpriteNode(texture: SKTexture(image: rightImage))
        
        currentNode = imageRightNode
        addChild(currentNode)
    }
    
    /// Обновление позиции и логики отображения за кадр (аналог draw / getImageForDraw)
    public func updateBubblePosition() {
        // Логика привязки к координатам спрайта и проверка границ экрана (switchLogic)
        switchLogic()
    }
    
    private func switchLogic() {
        let screenWidth: CGFloat = 800.0 // Виртуальная ширина экрана проекта
        
        if drawRight && (currentNode.position.x + currentNode.size.width / 2 > screenWidth / 2) {
            drawRight = false
            currentNode.removeFromParent()
            currentNode = imageLeftNode
            addChild(currentNode)
        } else if !drawRight && (currentNode.position.x - currentNode.size.width / 2 < -screenWidth / 2) {
            drawRight = true
            currentNode.removeFromParent()
            currentNode = imageRightNode
            addChild(currentNode)
        }
    }
    
    private func drawBubbleOnCanvas(lines: [String], right: Bool) -> UIImage {
        let fontSize: CGFloat = 14.0
        let padding: CGFloat = 10.0
        let lineSpacing: CGFloat = 4.0
        let borderThickness: CGFloat = 3.0
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        
        var maxWidth: CGFloat = 0.0
        var totalHeight: CGFloat = padding * 2
        
        let measuredLines = lines.map { line -> (String, CGSize) in
            let size = (line as NSString).size(withAttributes: attributes)
            if size.width > maxWidth { maxWidth = size.width }
            totalHeight += size.height + lineSpacing
            return (line, size)
        }
        
        let width = max(maxWidth + 55.0, 148.0)
        let height = max(totalHeight, 40.0)
        let bubbleSize = CGSize(width: width, height: height + 30.0) // Дополнительное место под хвостик
        
        // Рендерим через CoreGraphics (аналог Android Canvas & Bitmap)
        let renderer = UIGraphicsImageRenderer(size: bubbleSize)
        return renderer.image { context in
            let cgContext = context.cgContext
            
            // Основной черный контур скругленного прямоугольника
            let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
            let path = UIBezierPath(roundedRect: rect, cornerRadius: 10.0)
            UIColor.black.setFill()
            path.fill()
            
            // Внутренний белый прямоугольник
            let innerRect = rect.insetBy(dx: borderThickness, dy: borderThickness)
            let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: 7.0)
            UIColor.white.setFill()
            innerPath.fill()
            
            // Отрисовка текста
            UIColor.black.set()
            var currentY: CGFloat = padding + 5.0
            for (line, size) in measuredLines {
                let x = (width - size.width) / 2.0
                line.draw(at: CGPoint(x: x, y: currentY), withAttributes: attributes)
                currentY += size.height + lineSpacing
            }
            
            // Отрисовка хвостика (SAY или THINK)
            if type == 1 { // SAY_BRICK
                let trianglePath = UIBezierPath()
                let offset: CGFloat = right ? 30.0 : width - 50.0
                trianglePath.move(to: CGPoint(x: offset, y: height))
                trianglePath.addLine(to: CGPoint(x: offset + 15.0, y: height + 25.0))
                trianglePath.addLine(to: CGPoint(x: offset + 30.0, y: height))
                trianglePath.close()
                UIColor.black.setFill()
                trianglePath.fill()
            }
        }
    }
    
    public func close() {
        removeFromParent()
    }
    
    // MARK: - Форматирование текста по аналогии с оригиналом
    
    public static func formatStringForBubbleBricks(text: String) -> [String] {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let maxLength = 30 // Максимальная длина строки в бульбашке
        var words: [String] = []
        
        trimmed.enumerateSubstrings(in: trimmed.startIndex..., options: [.byWords, .localized]) { substring, _, _, _ in
            if let word = substring {
                words.append(word)
            }
        }
        
        var lines: [String] = []
        var currentLine = ""
        
        for word in words {
            if currentLine.isEmpty {
                currentLine = word
            } else if currentLine.count + 1 + word.count < maxLength {
                currentLine += " " + word
            } else {
                lines.append(currentLine)
                currentLine = word
            }
        }
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }
        return lines.isEmpty ? [text] : lines
    }
}
