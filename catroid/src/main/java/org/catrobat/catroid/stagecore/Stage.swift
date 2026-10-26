import Foundation

/// Замена scene2d.Stage (корневая группа + диспетчер касаний). Рендер — SpriteKit (см. StageListener).
public final class Stage {
    public let root = Group()
    public var actors: [Actor] { return root.children }

    public init() {}

    public func addActor(_ a: Actor) { root.addActor(a) }
    public func act(_ delta: Float) { root.act(delta) }

    /// Касания пересылаются Look-ам сверху вниз
    public func touchDown(x: Float, y: Float, pointer: Int, button: Int) -> Bool {
        for actor in root.children.reversed() {
            if let look = actor as? Look,
               look.touchDown(x: x - look.x, y: y - look.y, pointer: pointer, stageX: x, stageY: y) { return true }
        }
        return false
    }

    public func touchUp(x: Float, y: Float, pointer: Int, button: Int) {
        TouchUtil.touchUp(pointer: pointer)
    }
}
