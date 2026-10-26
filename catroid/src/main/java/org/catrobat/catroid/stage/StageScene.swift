import SpriteKit
import Foundation

public class StageScene: SKScene {
    
    public static let tag = "StageScene"
    
    // Флаги состояния (аналоги из Java)
    public var isPausedState: Bool = true
    public var isFinished: Bool = false
    public var firstFrameDrawn: Bool = false
    
    // Виртуальные размеры сцены (аналоги virtualWidth / virtualHeight)
    public var virtualWidth: CGFloat = 800.0
    public var virtualHeight: CGFloat = 480.0
    
    // Список спрайтов на сцене
    private var sprites: [Sprite] = []
    private var bubbleActors: [ObjectIdentifier: ShowBubbleActor] = [:]
    public private(set) var actors: [Actor] = []
    public private(set) var textNodes: [SKNode] = []

    public func addActor(_ actor: Actor) {
        if !actors.contains(where: { $0 === actor }) { actors.append(actor) }
    }

    public func addActor(_ node: SKNode) {
        if !textNodes.contains(where: { $0 === node }) { textNodes.append(node) }
        if node.parent !== self { addChild(node) }
    }

    public func removeTextNode(_ node: SKNode) {
        textNodes.removeAll { $0 === node }
        node.removeFromParent()
    }

    // MARK: - Bubble and clone compatibility APIs

    public func getBubbleActorForSprite(_ sprite: Sprite) -> ShowBubbleActor? {
        bubbleActors[ObjectIdentifier(sprite)]
    }

    public func setBubbleActorForSprite(_ sprite: Sprite, showBubbleActor bubble: ShowBubbleActor) {
        let key = ObjectIdentifier(sprite)
        if let previous = bubbleActors[key], previous !== bubble {
            previous.removeFromParent()
        }
        bubbleActors[key] = bubble
        if bubble.parent !== self { addChild(bubble) }
    }

    public func removeBubbleActorForSprite(_ sprite: Sprite) {
        guard let bubble = bubbleActors.removeValue(forKey: ObjectIdentifier(sprite)) else { return }
        bubble.close()
    }

    @discardableResult
    public func removeClonedSpriteFromStage(_ sprite: Sprite) -> Bool {
        guard sprite.isClone else { return false }
        removeBubbleActorForSprite(sprite)
        sprites.removeAll { $0 === sprite }
        return true
    }

    public func registerSprite(_ sprite: Sprite) {
        if !sprites.contains(where: { $0 === sprite }) { sprites.append(sprite) }
    }
    
    override public func didMove(to view: SKView) {
        super.didMove(to: view)
        
        print("[\(StageScene.tag)] Stage scene created and moved to view.")
        
        // Инициализация размеров, камеры и физического мира
        setupVirtualScreen()
        loadSceneContent()
    }
    
    private func setupVirtualScreen() {
        // Настройка масштабирования под размер экрана iOS-устройства (аналог ExtendViewport / ScalingViewport)
        scaleMode = .aspectFit
    }
    
    private func loadSceneContent() {
        // Загрузка спрайтов текущей сцены, добавление их на SKScene
        // Аналог initActors(sprites) из Java-кода
        print("[\(StageScene.tag)] Loading sprites and actors...")
        
        isPausedState = false
        firstFrameDrawn = true
    }
    
    // MARK: - Игровой цикл (аналог render() в LibGDX)
    override public func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if isFinished || isPausedState {
            return
        }
        
        // Здесь происходит обновление физики, скриптов и действий спрайтов за кадр (Delta Time)
        // Аналог stage.act(optimizedDeltaTime) и physicsWorld.step(...)
    }
    
    // MARK: - Управление состоянием (Pause / Resume / Finish)
    
    public func pauseScene() {
        isPausedState = true
        print("[\(StageScene.tag)] Scene paused.")
    }
    
    public func resumeScene() {
        isPausedState = false
        print("[\(StageScene.tag)] Scene resumed.")
    }
    
    public func finishScene() {
        isFinished = true
        print("[\(StageScene.tag)] Scene finished.")
    }
    
    // MARK: - Работа со спрайтами и клонами
    
    public func cloneSprite(_ cloneMe: Sprite) {
        // Логика клонирования спрайта на iOS-сцене
        print("[\(StageScene.tag)] Cloning sprite...")
    }
    
    public func removeClonedSprite(_ sprite: Sprite) -> Bool {
        // Удаление клона со сцены
        return true
    }
}
