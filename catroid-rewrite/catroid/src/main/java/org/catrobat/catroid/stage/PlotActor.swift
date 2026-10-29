import SpriteKit
import UIKit

public class PlotActor: SKNode {
    
    private var virtualWidth: CGFloat
    private var virtualHeight: CGFloat
    private var screenRatio: CGFloat
    
    // Текстурный узел для отображения нарисованного графика
    private var canvasNode: SKSpriteNode!
    private var canvasTexture: SKTexture?
    private var coreGraphicsImage: UIImage?
    
    private let renderContext: UIGraphicsImageRenderer
    
    public init(virtualWidth: CGFloat, virtualHeight: CGFloat) {
        self.virtualWidth = virtualWidth
        self.virtualHeight = virtualHeight
        
        // Вычисление соотношения экрана (аналог calculateScreenRatio)
        let screenBounds = UIScreen.main.bounds
        let deviceDiagonal = sqrt(pow(screenBounds.width, 2) + pow(screenBounds.height, 2))
        let creatorDiagonal = sqrt(pow(virtualWidth, 2) + pow(virtualHeight, 2))
        self.screenRatio = creatorDiagonal / deviceDiagonal
        
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
        let blankImage = renderContext.image { context in
            UIColor.clear.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
        
        canvasTexture = SKTexture(image: blankImage)
        canvasNode = SKSpriteNode(texture: canvasTexture, size: size)
        // Центрируем холст (-virtualWidth/2, -virtualHeight/2), как в оригинале Catroid
        canvasNode.position = .zero
        addChild(canvasNode)
    }
    
    /// Очистка холста графика (аналог reset)
    public func reset() {
        coreGraphicsImage = renderContext.image { context in
            UIColor.clear.setFill()
            context.fill(CGRect(x: 0, y: 0, width: virtualWidth, height: virtualHeight))
        }
        updateTexture()
    }
    
    /// Отрисовка линий графиков для спрайтов (аналог draw / drawLinesForSprite)
    public func updatePlots(sprites: [Sprite]) {
        coreGraphicsImage = renderContext.image { context in
            // Рисуем предыдущее состояние холста
            coreGraphicsImage?.draw(at: .zero)
            
            // Проходим по спрайтам и рисуем новые линии графиков
            for sprite in sprites {
                // let plot = sprite.plot
                // plot.drawLinesForSprite(screenRatio, camera)
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
