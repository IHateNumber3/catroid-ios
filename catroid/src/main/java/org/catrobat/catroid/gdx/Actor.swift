import Foundation
import CoreGraphics

public enum Touchable { case enabled, disabled, childrenOnly }

/// Мини-замена scene2d.Actor (позиция/размер/origin/scale/rotation, действия, слушатели).
open class Actor {
    private var xStorage: Float = 0
    private var yStorage: Float = 0
    private var rotationStorage: Float = 0
    /// Виртуальные геттеры (PhysicsLook переопределяет их, как getX()/getY()/getRotation() в Java)
    open var x: Float { return xStorage }
    open var y: Float { return yStorage }
    open var rotation: Float { return rotationStorage }
    public private(set) var width: Float = 0
    public private(set) var height: Float = 0
    public var originX: Float = 0
    public var originY: Float = 0
    public private(set) var scaleX: Float = 1
    public private(set) var scaleY: Float = 1

    public var visible = true
    public var touchable: Touchable = .enabled
    public weak var parent: Group?
    public var zIndex: Int = 0

    public var actions: [Action] = []
    public var listeners: [EventListener] = []

    public init() {}

    // MARK: transform
    open func setX(_ v: Float) { if xStorage != v { xStorage = v; positionChanged() } }
    open func setY(_ v: Float) { if yStorage != v { yStorage = v; positionChanged() } }
    open func setPosition(_ nx: Float, _ ny: Float) {
        if xStorage != nx || yStorage != ny { xStorage = nx; yStorage = ny; positionChanged() }
    }
    public func setWidth(_ v: Float) { if width != v { width = v; sizeChanged() } }
    public func setHeight(_ v: Float) { if height != v { height = v; sizeChanged() } }
    public func setSize(_ w: Float, _ h: Float) {
        if width != w || height != h { width = w; height = h; sizeChanged() }
    }
    public func setBounds(_ nx: Float, _ ny: Float, _ w: Float, _ h: Float) {
        let moved = xStorage != nx || yStorage != ny
        let resized = width != w || height != h
        xStorage = nx; yStorage = ny; width = w; height = h
        if moved { positionChanged() }
        if resized { sizeChanged() }
    }
    public func setOrigin(_ ox: Float, _ oy: Float) { originX = ox; originY = oy }
    open func setScale(_ sx: Float, _ sy: Float) {
        if scaleX != sx || scaleY != sy { scaleX = sx; scaleY = sy; scaleChanged() }
    }
    open func setRotation(_ degrees: Float) {
        if rotationStorage != degrees { rotationStorage = degrees; rotationChanged() }
    }

    open func positionChanged() {}
    open func sizeChanged() {}
    open func scaleChanged() {}
    open func rotationChanged() {}

    // MARK: actions
    open func act(_ delta: Float) {
        var i = 0
        while i < actions.count {
            let a = actions[i]
            if a.act(delta) {
                if let idx = actions.firstIndex(where: { $0 === a }) { actions.remove(at: idx) }
            } else { i += 1 }
        }
    }

    public func addAction(_ action: Action) {
        action.actor = self
        actions.append(action)
    }

    /// Compatibility accessor used by actions ported from scene2d.
    public func getActions() -> [Action] { actions }

    public func clearActions() {
        actions.forEach { $0.actor = nil }
        actions.removeAll()
    }

    // MARK: events
    public func addListener(_ l: EventListener) { listeners.append(l) }
    public func removeListener(_ l: EventListener) { listeners.removeAll { $0 === l } }
    public func clearListeners() { listeners.removeAll() }

    /// Упрощённый fire: слушатели цели, затем bubbling по родителям.
    @discardableResult
    public func fire(_ event: Event) -> Bool {
        var handled = false
        for l in listeners where l.handle(event) { handled = true }
        var p = parent
        while let g = p {
            for l in g.listeners where l.handle(event) { handled = true }
            p = g.parent
        }
        return handled
    }

    @discardableResult
    open func remove() -> Bool {
        guard let g = parent else { return false }
        return g.removeActor(self)
    }

    /// Хит-тест по локальным координатам цели (прямоугольник без поворота; точный тест делает Look).
    open func hit(x px: Float, y py: Float, touchable t: Bool) -> Actor? {
        if t && touchable != .enabled { return nil }
        if !visible { return nil }
        return (px >= 0 && px < width && py >= 0 && py < height) ? self : nil
    }
}

open class Group: Actor {
    public private(set) var children: [Actor] = []

    public func addActor(_ a: Actor) {
        a.remove()
        children.append(a)
        a.parent = self
        reindex()
    }

    @discardableResult
    public func removeActor(_ a: Actor) -> Bool {
        guard let i = children.firstIndex(where: { $0 === a }) else { return false }
        children.remove(at: i)
        a.parent = nil
        reindex()
        return true
    }

    public func setZIndex(of a: Actor, _ index: Int) {
        guard let i = children.firstIndex(where: { $0 === a }) else { return }
        children.remove(at: i)
        children.insert(a, at: max(0, min(index, children.count)))
        reindex()
    }

    private func reindex() {
        for (i, c) in children.enumerated() { c.zIndex = i }
    }

    open override func act(_ delta: Float) {
        super.act(delta)
        for c in children { c.act(delta) }
    }

    /// Хит в координатах сцены (у корневой группы stage сдвиг = 0), сверху вниз.
    open override func hit(x px: Float, y py: Float, touchable t: Bool) -> Actor? {
        for c in children.reversed() {
            if let h = c.hit(x: px, y: py, touchable: t) { return h }
        }
        return nil
    }
}
