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
    public var spritesFromStage: [Sprite] { sprites }
    private var bubbleActors: [ObjectIdentifier: ShowBubbleActor] = [:]
    public private(set) var actors: [Actor] = []
    public private(set) var textNodes: [SKNode] = []

    public func addActor(_ actor: Actor) {
        if !actors.contains(where: { $0 === actor }) { actors.append(actor) }
        if let look = actor as? Look, look.node.parent !== self { addChild(look.node) }
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

    /// Releases a synthetic touch pointer used by translated Pocket Code actions.
    public func touchUp(x: Int, y: Int, pointer: Int, button: Int) {
        TouchUtil.touchUp(pointer: pointer)
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
        print("[\(StageScene.tag)] Loading sprites and actors...")
        guard let scene = ProjectManager.shared.currentlyPlayingScene else {
            isPausedState = false
            firstFrameDrawn = true
            return
        }
        loadScene(scene)
        isPausedState = false
        firstFrameDrawn = true
    }

    /// Rebuilds the visible actor layer for the selected Catrobat scene.
    public func loadScene(_ scene: Scene) {
        for sprite in sprites { sprite.look.node.removeFromParent() }
        actors.removeAll { $0 is Look }
        sprites = scene.spriteList
        for sprite in sprites {
            if sprite.look.lookData == nil, let firstLook = sprite.lookList.first { sprite.look.setLookData(firstLook) }
            addActor(sprite.look)
            sprite.initConditionScriptTriggers()
            sprite.initIfConditionBrickTriggers()
            sprite.initializeEventThreads(startType: .start)
        }
        cameraPositionerResetIfAvailable()
    }

    private func cameraPositionerResetIfAvailable() {
        StageListener.shared.cameraPositioner.reset()
    }
    
    // MARK: - Game loop (iOS equivalent of scene2d Stage.act)
    private var previousFrameTime: TimeInterval = 0
    override public func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        guard !isFinished, !isPausedState else { previousFrameTime = currentTime; return }
        let rawDelta = previousFrameTime > 0 ? currentTime - previousFrameTime : 1.0 / 60.0
        previousFrameTime = currentTime
        let delta = Float(min(max(rawDelta, 0), 0.1))
        for actor in actors { actor.act(delta) }
        StageListener.shared.cameraPositioner.updateCameraPositionForFocusedSprite()
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
