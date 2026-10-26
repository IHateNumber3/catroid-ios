import Foundation
import SpriteKit

/// Каркас StageListener: хранит состояние сцены; рендер подключается в SKScene.
/// TODO(port): полноценный порт StageListener.java (цикл кадра, пауза, скриншоты, перо).
public final class StageListener {

    public var stage = Stage()
    public let shapeRenderer = ShapeRenderer()
    public var firstFrameDrawn = false
    public var penActor = PenActor()
    public var embroideryPatternManager = EmbroideryPatternManager()

    private var clonedSprites: [Sprite] = []
    private var bubbleActors: [Sprite: ShowBubbleActor] = [:]

    public init() {}

    public func getSpritesFromStage() -> [Sprite] {
        let scene = ProjectManager.shared.currentlyPlayingScene
        return (scene?.spriteList ?? []) + clonedSprites
    }

    public func getAllClonesOfSprite(_ sprite: Sprite) -> [Sprite] {
        return clonedSprites.filter { $0.myOriginal == sprite }
    }

    public func addClonedSprite(_ sprite: Sprite) { clonedSprites.append(sprite) }

    public func removeClonedSpriteFromStage(_ sprite: Sprite) {
        clonedSprites.removeAll { $0 === sprite }
        sprite.look.remove()
    }

    public func addActor(_ actor: Actor) { stage.addActor(actor) }
    public func clearBackground() {}

    public func getBubbleActorForSprite(_ sprite: Sprite) -> ShowBubbleActor? { return bubbleActors[sprite] }
    public func removeBubbleActorForSprite(_ sprite: Sprite) { bubbleActors.removeValue(forKey: sprite) }
}
