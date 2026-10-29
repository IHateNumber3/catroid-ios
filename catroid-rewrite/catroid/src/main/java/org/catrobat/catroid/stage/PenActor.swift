import SpriteKit
import UIKit

public class PenActor: SKNode {
    
    private var virtualWidth: CGFloat
    private var virtualHeight: CGFloat
    private var screenRatio: CGFloat
    
    // Текстурный узел для отображения нарисованного холста пера
    private var canvasNode: SKSpriteNode!
    private var canvasTexture: SKTexture?
    private var coreGraphicsImage: UIImage?
    
    private let renderContext: UIGraphicsImageRenderer
    
    public init(virtualWidth: CGFloat, virtualHeight: CGFloat) {
        self.virtualWidth = virtualWidth
        self.virtualHeight = virtualHeight
        self.screenRatio = 1.0 // Можно вычислить относительно реального экрана iOS
        
        let size = CGSize(width: virtualWidth, height: virtualHeight)
        self.renderContext = UIGraphicsImageRenderer(size: size)
        
        super.init()
        
        setupCanvas(size: size)
        reset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCanvas(size: CGSize) {
        // Создаем пустую текстуру для холста пера
        let blankImage = renderContext.image { context in
            UIColor.clear.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        canvasTexture = SKTexture(image: blankImage)
        canvasNode = SKSpriteNode(texture: canvasTexture, size: size)
        // Центрируем холст, как в оригинале Catroid (-virtualWidth/2, -virtualHeight/2)
        canvasNode.position = .zero
        addChild(canvasNode)
    }
    
    /// Очистка холста пера (аналог reset)
    public func reset() {
        coreGraphicsImage = renderContext.image { context in
            UIColor.clear.setFill()
            context.fill(CGRect(x: 0, y: 0, width: virtualWidth, height: virtualHeight))
        }
        updateTexture()
    }
    
    /// Отрисовка линий и штампов за кадр (аналог draw / stampToFrameBuffer)
    public func updatePenAndStamps(sprites: [Sprite]) {
        // Рендерим новые линии и штампы через CoreGraphics контекст в UIImage
        coreGraphicsImage = renderContext.image { context in
            // Сначала рисуем предыдущий холст
            coreGraphicsImage?.draw(at: .zero)
            
            // Проходим по спрайтам и рисуем линии/штампы пером
            for sprite in sprites {
                // let pen = sprite.penConfiguration
                // pen.drawLines(...)
                // if pen.hasStamp() { drawStamp(...) }
            }
        }
        updateTexture()
    }
    
    private func updateTexture() {
        guard let image = coreGraphicsImage else { return }
        canvasTexture = SKTexture(image: image)
        canvasNode.texture = canvasTexture
    }
    
    public func dispose() {
        canvasTexture = nil
        coreGraphicsImage = nil
        removeAllChildren()
    }
}
