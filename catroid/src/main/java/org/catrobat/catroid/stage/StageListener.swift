import SpriteKit
import Foundation

public class StageScene: SKScene {
    
    // MARK: - Properties
    public var isStagePaused: Bool = true
    public var isFinished: Bool = false
    public var firstFrameDrawn: Bool = false
    
    // Виртуальные размеры сцены (соответствуют проекту Catrobat)
    public var virtualWidth: CGFloat = 800.0
    public var virtualHeight: CGFloat = 480.0
    
    private var virtualWidthHalf: CGFloat { return virtualWidth / 2.0 }
    private var virtualHeightHalf: CGFloat { return virtualHeight / 2.0 }
    
    public var cameraPositioner: CameraPositioner?
    public var gameCamera: SKCameraNode = SKCameraNode()
    
    private var sprites: [Sprite] = []
    private var bubbleActorMap: [Sprite: ShowBubbleActor] = [:]
    
    public var deltaActionTimeDivisor: Float = 10.0
    public var axesOn: Bool = false
    
    // MARK: - Scene Lifecycle
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Настройка камеры сцены
        self.camera = gameCamera
        self.addChild(gameCamera)
        
        cameraPositioner = CameraPositioner(
            camera: gameCamera,
            virtualHeightHalf: virtualHeightHalf,
            virtualWidthHalf: virtualWidthHalf
        )
        
        setupStage()
    }
    
    private func setupStage() {
        isStagePaused = false
        // Инициализация начальных триггеров и спрайтов сцены
        print("[StageScene] Stage created and initialized.")
    }
    
    // MARK: - Game Loop (Аналог render() в LibGDX)
    
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if isStagePaused || isFinished {
            return
        }
        
        // Обновление логики камеры и следования за сфокусированным спрайтом
        cameraPositioner?.updateCameraPositionForFocusedSprite()
        
        if !firstFrameDrawn {
            firstFrameDrawn = true
        }
    }
    
    // MARK: - Scene Management & Clones
    
    public func cloneSpriteAndAddToStage(_ cloneMe: Sprite) {
        // Логика клонирования спрайта для визуального программирования
        let copy = cloneMe.copyForClone()
        sprites.append(copy)
        addChild(copy.node)
    }
    
    public func removeClonedSpriteFromStage(_ sprite: Sprite) -> Bool {
        guard sprite.isClone else { return false }
        if let index = sprites.firstIndex(of: sprite) {
            sprites.remove(at: index)
            sprite.node.removeFromParent()
            return true
        }
        return false
    }
    
    // MARK: - Pause / Resume
    
    public func menuResume() {
        isStagePaused = false
    }
    
    public func menuPause() {
        isStagePaused = true
    }
    
    // MARK: - Bubbles & Dialogs
    
    public func setBubbleActorForSprite(_ sprite: Sprite, showBubbleActor: ShowBubbleActor) {
        addChild(showBubbleActor)
        bubbleActorMap[sprite] = showBubbleActor
    }
    
    public func removeBubbleActorForSprite(_ sprite: Sprite) {
        guard let bubble = bubbleActorMap[sprite] else { return }
        bubble.close()
        bubble.removeFromParent()
        bubbleActorMap.removeValue(forKey: sprite)
    }
}
