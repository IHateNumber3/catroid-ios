import Foundation
import SpriteKit

/// Compatibility bridge used by translated Catroid actions.
/// The active scene is owned by StageViewController.
public final class StageListener {
    public static let shared = StageListener()
    private init() {}

    public var stage: StageScene {
        if let scene = StageViewController.activeStage?.currentStageScene { return scene }
        return StageScene(size: CGSize(width: 800, height: 480))
    }

    public var shapeRenderer: ShapeRenderer? { nil }
    public var penActor: PenActor {
        if let actor = stage.childNode(withName: "__catroid_pen_actor") as? PenActor { return actor }
        let actor = PenActor(virtualWidth: stage.virtualWidth, virtualHeight: stage.virtualHeight)
        actor.name = "__catroid_pen_actor"
        stage.addChild(actor)
        return actor
    }

    public func addActor(_ actor: Actor) { stage.addActor(actor) }
    public func addActor(_ node: SKNode) { stage.addActor(node) }
    public func clearBackground() { stage.backgroundColor = .black }
    public func getBubbleActorForSprite(_ sprite: Sprite) -> ShowBubbleActor? { stage.getBubbleActorForSprite(sprite) }
    public func setBubbleActorForSprite(_ sprite: Sprite, _ bubble: ShowBubbleActor) { stage.setBubbleActorForSprite(sprite, showBubbleActor: bubble) }
    public func removeBubbleActorForSprite(_ sprite: Sprite) { stage.removeBubbleActorForSprite(sprite) }
    public func removeClonedSpriteFromStage(_ sprite: Sprite) { _ = stage.removeClonedSpriteFromStage(sprite) }
    public func transitionToScene(_ name: String) { }
}
