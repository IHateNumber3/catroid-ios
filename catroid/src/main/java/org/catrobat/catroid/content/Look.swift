import Foundation
import UIKit
import SpriteKit

// Swift-side constants matching physics/ParticleConstants.kt in the Android source.
enum ParticleConstants {
    static let velocityHighMin: Float = 120
    static let velocityHighMax: Float = 300
    static let lifeHighMaxActive: Float = 1000
    static let lifeHighMaxDead: Float = 5000
    static let particleScale: Float = 32
}

/// Look = scene2d Actor (логика/трансформ) + SKSpriteNode (отрисовка).
/// Система координат как в libGDX: y вверх, x/y — левый нижний угол неповёрнутого прямоугольника.
open class Look: Actor {

    // MARK: - Constants
    public static let rotationStyleLeftRightOnly = 0
    public static let rotationStyleAllAround = 1
    public static let rotationStyleNone = 2
    public static let degreeUIOffset: Float = 90.0
    private static let colorScale: Float = 200.0

    // MARK: - State
    private var lookVisible = true
    private var simultaneousMovementXY = false
    private var lookListIndexBeforeLookRequestStorage = -1
    public private(set) var lookData: LookData?
    public private(set) weak var sprite: Sprite?
    public private(set) var alpha: Float = 1
    public private(set) var brightness: Float = 1
    var hue: Float = 0
    var pixmap: Pixmap?
    private var shader: SKShader?
    private var rotationMode = Look.rotationStyleAllAround
    private var stageRotation: Float = 90          // Java: private float rotation
    private var realRotation: Float = 90
    private var scheduler: ThreadScheduler?
    private var lastDelta: Float = 1.0 / 60.0
    private let lock = NSRecursiveLock()

    /// Узел для рендера (его добавляет в сцену StageListener).
    public let node = SKSpriteNode()

    // particles
    private var particleEmitterNode: SKEmitterNode?
    public var hasParticleEffect = false
    public var isAdditive = true
    private var particleEffectPaused = false

    public init(sprite: Sprite) {
        self.sprite = sprite
        super.init()
        scheduler = ThreadScheduler(actor: self)
        setBounds(0, 0, 0, 0)
        setOrigin(0, 0)
        setScale(1, 1)
        setRotation(0)
        touchable = .enabled
        node.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addListener(EventWrapperListener(look: self))
    }

    private func sync<T>(_ body: () -> T) -> T {
        lock.lock(); defer { lock.unlock() }
        return body()
    }

    // MARK: - Touch (замена InputListener.touchDown)

    /// Вызывается Stage при касании. x/y — локальные координаты внутри Look, stageX/Y — сцены.
    public func touchDown(x: Float, y: Float, pointer: Int, stageX: Float, stageY: Float) -> Bool {
        if doTouchDown(x: x, y: y, pointer: pointer) { return true }
        touchable = .disabled
        if let target = parent?.hit(x: stageX, y: stageY, touchable: true) {
            let ev = TouchEvent(stageX: stageX, stageY: stageY, pointer: pointer)
            target.fire(ev)
        }
        touchable = .enabled
        return false
    }

    public func doTouchDown(x px: Float, y py: Float, pointer: Int) -> Bool {
        if !isLookVisible { return false }
        var x = px
        var y = py
        if isFlipped() { x = (width - 1) - x }
        y = (height - 1) - y
        if x >= 0 && x < width && y >= 0 && y < height,
           let pixmap = pixmap, (pixmap.getPixel(Int(x), Int(y)) & 0xFF) > 10 {
            sprite?.look.fire(EventWrapper(eventId: EventId(EventId.tap), waitForCompletion: false))
            return true
        }
        return false
    }

    open override func hit(x px: Float, y py: Float, touchable t: Bool) -> Actor? {
        if t && touchable != .enabled { return nil }
        if !visible || !isLookVisible { return nil }
        // px/py — координаты сцены → локальные (без учёта поворота/масштаба, как Image.hit в libGDX
        // для неповёрнутого актёра); точная проверка по пикселям — в touchDown.
        let lx = px - x, ly = py - y
        return (lx >= 0 && lx < width && ly >= 0 && ly < height) ? self : nil
    }

    public func setZIndex(_ index: Int) {
        if let parent = self.parent { parent.setZIndex(of: self, index) } else { self.zIndex = index }
    }

    // MARK: - Visibility
    public var isLookVisible: Bool {
        get { return sync { lookVisible } }
    }
    public func setLookVisible(_ v: Bool) { sync { lookVisible = v } }

    public var lookListIndexBeforeLookRequest: Int {
        get { return sync { lookListIndexBeforeLookRequestStorage } }
        set { sync { lookListIndexBeforeLookRequestStorage = newValue } }
    }

    // MARK: - Lifecycle

    @discardableResult
    open override func remove() -> Bool {
        notifyAllWaiters()
        setLookVisible(false)
        let result = super.remove()
        clearListeners()
        clearActions()
        scheduler = nil
        sprite = nil
        lookData = nil
        node.removeFromParent()
        return result
    }

    public func copyTo(_ destination: Look) {
        destination.setLookVisible(isLookVisible)
        destination.setPositionInUserInterfaceDimensionUnit(xInUserInterfaceDimensionUnit, yInUserInterfaceDimensionUnit)
        destination.setSizeInUserInterfaceDimensionUnit(sizeInUserInterfaceDimensionUnit)
        destination.setTransparencyInUserInterfaceDimensionUnit(transparencyInUserInterfaceDimensionUnit)
        destination.setColorInUserInterfaceDimensionUnit(colorInUserInterfaceDimensionUnit)
        destination.setRotationMode(rotationMode)
        destination.setMotionDirectionInUserInterfaceDimensionUnit(motionDirectionInUserInterfaceDimensionUnit)
        destination.setBrightnessInUserInterfaceDimensionUnit(brightnessInUserInterfaceDimensionUnit)
        destination.hasParticleEffect = hasParticleEffect
        destination.isAdditive = isAdditive
    }

    // MARK: - Shader (brightness / contrast / hue)

    private static let shaderSource = """
    vec3 rgb2hsv(vec3 c) {
        vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
        vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
        vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
        float d = q.x - min(q.w, q.y);
        float e = 1.0e-10;
        return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
    }
    vec3 hsv2rgb(vec3 c) {
        vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
        vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
        return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
    }
    void main() {
        vec4 color = SKDefaultShading();
        if (color.a > 0.0) {
            color.rgb /= color.a;
            color.rgb = ((color.rgb - 0.5) * max(u_contrast, 0.0)) + 0.5;
            color.rgb += u_brightness;
            color.rgb *= color.a;
            vec3 hsv = rgb2hsv(color.rgb);
            hsv.x += u_hue;
            color.rgb = hsv2rgb(hsv);
        }
        gl_FragColor = color;
    }
    """

    public func createBrightnessContrastHueShader() {
        sync {
            let s = SKShader(source: Look.shaderSource, uniforms: [
                SKUniform(name: "u_brightness", float: brightness - 1),
                SKUniform(name: "u_contrast", float: 1),
                SKUniform(name: "u_hue", float: hue)
            ])
            shader = s
            node.shader = s
        }
    }

    private func createShaderIfNotExisting() {
        if shader == nil { createBrightnessContrastHueShader() }
    }

    private func refreshShader() {
        createShaderIfNotExisting()
        shader?.uniformNamed("u_brightness")?.floatValue = brightness - 1
        shader?.uniformNamed("u_hue")?.floatValue = hue
    }

    // MARK: - Particles (SKEmitterNode вместо gdx ParticleEffect)

    public var particleEmitter: SKEmitterNode {
        if particleEmitterNode == nil { initialiseParticleEffect() }
        return particleEmitterNode!
    }

    private func initialiseParticleEffect() {
        let emitter = SKEmitterNode(fileNamed: "particles") ?? SKEmitterNode()
        emitter.targetNode = node.parent
        particleEmitterNode = emitter
        node.addChild(emitter)
    }

    public func pauseParticleEffect() { particleEffectPaused = true; particleEmitterNode?.isPaused = true }
    public func resumeParticleEffect() { particleEffectPaused = false; particleEmitterNode?.isPaused = false }
    public var isParticleEffectPaused: Bool { return particleEffectPaused }

    public func clearParticleEffect() {
        particleEmitterNode?.removeFromParent()
        particleEmitterNode = nil
    }

    private func setupParticleEffects(_ emitter: SKEmitterNode) {
        guard let sprite = sprite else { return }
        let look = sprite.look!
        emitter.position = .zero          // дочерний узел: центр спрайта
        let spriteSize = look.sizeInUserInterfaceDimensionUnit / 2
        var pScale: Float = 1
        if sprite.lookList.isEmpty {
            pScale = spriteSize / ParticleConstants.particleScale
        }
        emitter.particleScale = CGFloat(spriteSize / 100)
        emitter.particleSpeed = CGFloat(ParticleConstants.velocityHighMax * pScale)
        emitter.particleSpeedRange = CGFloat((ParticleConstants.velocityHighMax - ParticleConstants.velocityHighMin) * pScale)
        emitter.yAcceleration = CGFloat(ProjectManager.shared.currentlyPlayingScene.getPhysicsWorld().gravity.y)
        emitter.particleBlendMode = isAdditive ? .add : .alpha
    }

    private func fadeInParticles() {
        let e = particleEmitter
        setupParticleEffects(e)
        e.particleLifetime = CGFloat(ParticleConstants.lifeHighMaxActive / 1000)
        if e.particleBirthRate == 0 { e.particleBirthRate = 100 }
    }

    private func fadeOutParticles() {
        let e = particleEmitter
        setupParticleEffects(e)
        e.particleLifetime = CGFloat(ParticleConstants.lifeHighMaxDead / 1000)
        e.particleBirthRate = 0   // continuous = false
    }

    // MARK: - Frame

    /// Замена draw(): синхронизирует состояние с SKSpriteNode. Вызывается из act().
    /// Хук перед отрисовкой (PhysicsLook.draw → checkHangup)
    open func willRender() {}

    private func updateRendering() {
        willRender()
        if !particleEffectPaused {
            if hasParticleEffect {
                fadeInParticles()
            } else if particleEmitterNode != nil {
                fadeOutParticles()
            }
        }
        visible = alpha != 0.0
        let hasTexture = lookData != nil && node.texture != nil
        node.isHidden = !(visible && isLookVisible && hasTexture)
        node.alpha = CGFloat(alpha)
        let flip: CGFloat = (lookData?.getTextureRegion().isFlipX ?? false) ? -1 : 1
        node.size = CGSize(width: CGFloat(width), height: CGFloat(height))
        node.position = CGPoint(x: CGFloat(x + originX), y: CGFloat(y + originY))
        node.xScale = CGFloat(scaleX) * flip
        node.yScale = CGFloat(scaleY)
        node.zRotation = CGFloat(rotation) * .pi / 180
        node.zPosition = CGFloat(zIndex)
    }

    open override func act(_ delta: Float) {
        lastDelta = delta
        scheduler?.tick(delta)
        if let sprite = sprite {
            sprite.runningStitch.update()
            sprite.evaluateConditionScriptTriggers()
        }
        updateRendering()
    }

    open override func positionChanged() {
        guard let sprite = sprite, !simultaneousMovementXY else { return }
        // Java вычисляет x/y внутри каждого условия — важно для PhysicsLook (getX() зависит от physicsObject)
        if sprite.penConfiguration.isPenDown {
            sprite.penConfiguration.addPosition(CGPoint(x: CGFloat(xInUserInterfaceDimensionUnit),
                                                        y: CGFloat(yInUserInterfaceDimensionUnit)))
        }
        let plot = sprite.plot
        if plot.isPlotting { plot.addPlotPoint(CGPoint(x: CGFloat(xInUserInterfaceDimensionUnit), y: CGFloat(yInUserInterfaceDimensionUnit))) }
        if plot.isCutting { plot.addCutPoint(CGPoint(x: CGFloat(xInUserInterfaceDimensionUnit), y: CGFloat(yInUserInterfaceDimensionUnit))) }
        if plot.isEngraving { plot.addEngravePoint(CGPoint(x: CGFloat(xInUserInterfaceDimensionUnit), y: CGFloat(yInUserInterfaceDimensionUnit))) }
        sprite.runningStitch.update()
    }

    // MARK: - Threads

    public func startThread(_ sequenceAction: ScriptSequenceAction) { scheduler?.startThread(sequenceAction) }
    public func stopThreads(_ threads: [Action]) { scheduler?.stopThreads(threads) }
    public func stopThreadWithScript(_ script: Script) { scheduler?.stopThreadsWithScript(script) }
    public func setSchedulerState(_ state: ThreadScheduler.SchedulerState) { scheduler?.setState(state) }
    public func haveAllThreadsFinished() -> Bool { return scheduler?.haveAllThreadsFinished() ?? true }

    func notifyAllWaiters() {
        for action in actions {
            (action as? ScriptSequenceActionWithWaiter)?.notifyWaiter()
        }
    }

    // MARK: - Textures / LookData

    public func refreshTextures(refreshShader doRefreshShader: Bool) {
        sync {
            guard let lookData = lookData else {
                setBounds(x + width / 2, y + height / 2, 0, 0)
                node.texture = nil
                return
            }
            pixmap = lookData.getPixmap()
            if let pixmap = pixmap {
                let newX = x - (Float(pixmap.width) - width) / 2
                let newY = y - (Float(pixmap.height) - height) / 2
                setSize(Float(pixmap.width), Float(pixmap.height))
                setPosition(newX, newY)
                setOrigin(width / 2, height / 2)
                node.texture = lookData.getTextureRegion().texture
                flipLookDataIfNeeded(rotationMode)
                if doRefreshShader { refreshShader() }
            }
        }
    }

    public func setLookData(_ lookData: LookData?) {
        sync {
            self.lookData = lookData
            refreshTextures(refreshShader: false)
        }
    }

    public var imagePath: String {
        return sync { lookData?.file.path ?? "" }
    }

    // MARK: - Position (UI units)

    public var xInUserInterfaceDimensionUnit: Float { return x + width / 2 }
    public func setXInUserInterfaceDimensionUnit(_ v: Float) { setX(v - width / 2) }
    public var yInUserInterfaceDimensionUnit: Float { return y + height / 2 }
    public func setYInUserInterfaceDimensionUnit(_ v: Float) { setY(v - height / 2) }

    public var distanceToTouchPositionInUserInterfaceDimensions: Float {
        let idx = TouchUtil.lastTouchIndex
        let dx = TouchUtil.getX(idx) - xInUserInterfaceDimensionUnit
        let dy = TouchUtil.getY(idx) - yInUserInterfaceDimensionUnit
        return Float(hypot(Double(dx), Double(dy)))
    }

    public var angularVelocityInUserInterfaceDimensionUnit: Float { return 0 }

    public var xVelocityInUserInterfaceDimensionUnit: Float {
        if let s = sprite, s.isGliding { return s.glidingVelocityX }
        return 0
    }
    public var yVelocityInUserInterfaceDimensionUnit: Float {
        if let s = sprite, s.isGliding { return s.glidingVelocityY }
        return 0
    }

    public func setPositionInUserInterfaceDimensionUnit(_ px: Float, _ py: Float) {
        adjustSimultaneousMovementXY(px, py)
        setXInUserInterfaceDimensionUnit(px)
        adjustSimultaneousMovementXY(xInUserInterfaceDimensionUnit, py)
        setYInUserInterfaceDimensionUnit(py)
    }

    private func adjustSimultaneousMovementXY(_ px: Float, _ py: Float) {
        simultaneousMovementXY = px != xInUserInterfaceDimensionUnit && py != yInUserInterfaceDimensionUnit
    }

    public func changeXInUserInterfaceDimensionUnit(_ d: Float) { setX(x + d) }
    public func changeYInUserInterfaceDimensionUnit(_ d: Float) { setY(y + d) }
    public func changePositionInInterfaceDimensionUnit(_ dx: Float, _ dy: Float) { setPosition(x + dx, y + dy) }

    public var widthInUserInterfaceDimensionUnit: Float { return width * sizeInUserInterfaceDimensionUnit / 100 }
    public var heightInUserInterfaceDimensionUnit: Float { return height * sizeInUserInterfaceDimensionUnit / 100 }

    // MARK: - Direction / rotation

    public var motionDirectionInUserInterfaceDimensionUnit: Float { return realRotation }

    public var lookDirectionInUserInterfaceDimensionUnit: Float {
        switch rotationMode {
        case Look.rotationStyleNone: return Look.degreeUIOffset
        case Look.rotationStyleAllAround: return realRotation
        case Look.rotationStyleLeftRightOnly: return isFlipped() ? -Look.degreeUIOffset : Look.degreeUIOffset
        default: return 0
        }
    }

    public func setRotationMode(_ mode: Int) {
        rotationMode = mode
        flipLookDataIfNeeded(mode)
    }

    public func getRotationMode() -> Int { return rotationMode }

    private func flipLookDataIfNeeded(_ mode: Int) {
        let orientedLeft = motionDirectionInUserInterfaceDimensionUnit < 0
        let differentModeButFlipped = mode != Look.rotationStyleLeftRightOnly && isFlipped()
        let facingWrongDirection = mode == Look.rotationStyleLeftRightOnly && (orientedLeft != isFlipped())
        if differentModeButFlipped || facingWrongDirection {
            lookData?.getTextureRegion().flip(x: true, y: false)
        }
    }

    public func setMotionDirectionInUserInterfaceDimensionUnit(_ degrees: Float) {
        stageRotation = (-degrees + Look.degreeUIOffset).truncatingRemainder(dividingBy: 360)
        realRotation = convertStageAngleToCatroidAngle(stageRotation)
        switch rotationMode {
        case Look.rotationStyleLeftRightOnly:
            setRotation(0)
            let orientedRight = realRotation >= 0
            let orientedLeft = realRotation < 0
            let needsFlipping = (isFlipped() && orientedRight) || (!isFlipped() && orientedLeft)
            if needsFlipping, let lookData = lookData {
                lookData.getTextureRegion().flip(x: true, y: false)
            }
        case Look.rotationStyleAllAround:
            setRotation(stageRotation)
        case Look.rotationStyleNone:
            setRotation(0)
        default: break
        }
    }

    public func isFlipped() -> Bool {
        return lookData?.getTextureRegion().isFlipX ?? false
    }

    public func changeDirectionInUserInterfaceDimensionUnit(_ change: Float) {
        setMotionDirectionInUserInterfaceDimensionUnit(
            (motionDirectionInUserInterfaceDimensionUnit + change).truncatingRemainder(dividingBy: 360))
    }

    // MARK: - Size / transparency / brightness / color

    public var sizeInUserInterfaceDimensionUnit: Float { return scaleX * 100 }

    public func setSizeInUserInterfaceDimensionUnit(_ percent: Float) {
        let p = max(0, percent)
        setScale(p / 100, p / 100)
    }

    public func changeSizeInUserInterfaceDimensionUnit(_ change: Float) {
        setSizeInUserInterfaceDimensionUnit(sizeInUserInterfaceDimensionUnit + change)
    }

    public var transparencyInUserInterfaceDimensionUnit: Float { return (1 - alpha) * 100 }

    public func setTransparencyInUserInterfaceDimensionUnit(_ percent: Float) {
        var p = percent
        if p < 100 {
            if p < 0 { p = 0 }
            visible = true
        } else {
            p = 100
            visible = false
        }
        alpha = (100 - p) / 100
    }

    public func changeTransparencyInUserInterfaceDimensionUnit(_ change: Float) {
        setTransparencyInUserInterfaceDimensionUnit(transparencyInUserInterfaceDimensionUnit + change)
    }

    public var brightnessInUserInterfaceDimensionUnit: Float { return brightness * 100 }

    public func setBrightnessInUserInterfaceDimensionUnit(_ percent: Float) {
        sync {
            brightness = min(200, max(0, percent)) / 100
            refreshTextures(refreshShader: true)
        }
    }

    public func changeBrightnessInUserInterfaceDimensionUnit(_ change: Float) {
        setBrightnessInUserInterfaceDimensionUnit(brightnessInUserInterfaceDimensionUnit + change)
    }

    public var colorInUserInterfaceDimensionUnit: Float { return hue * Look.colorScale }

    public func setColorInUserInterfaceDimensionUnit(_ value: Float) {
        sync {
            var v = value.truncatingRemainder(dividingBy: Look.colorScale)
            if v < 0 { v = Look.colorScale + v }
            hue = v / Look.colorScale
            refreshTextures(refreshShader: true)
        }
    }

    public func changeColorInUserInterfaceDimensionUnit(_ value: Float) {
        setColorInUserInterfaceDimensionUnit(colorInUserInterfaceDimensionUnit + value)
    }

    // MARK: - Angles

    private func isAngleInCatroidInterval(_ a: Float) -> Bool { return a > -180 && a <= 180 }

    public func breakDownCatroidAngle(_ angle: Float) -> Float {
        let a = angle.truncatingRemainder(dividingBy: 360)
        if a >= 0 && !isAngleInCatroidInterval(a) { return a - 360 }
        if a < 0 && !isAngleInCatroidInterval(a) { return a + 360 }
        return a
    }

    public func convertCatroidAngleToStageAngle(_ catroidAngle: Float) -> Float {
        return -breakDownCatroidAngle(catroidAngle) + Look.degreeUIOffset
    }

    public func convertStageAngleToCatroidAngle(_ stageAngle: Float) -> Float {
        return breakDownCatroidAngle(-stageAngle + Look.degreeUIOffset)
    }

    // MARK: - Hitbox / collision

    private func rotatePointAroundPoint(center: CGPoint, point: CGPoint, rotation: Float) -> CGPoint {
        let r = Double(rotation) * .pi / 180
        let s = sin(r), c = cos(r)
        let px = Double(point.x - center.x), py = Double(point.y - center.y)
        return CGPoint(x: px * c - py * s + Double(center.x), y: px * s + py * c + Double(center.y))
    }

    public func getHitbox() -> CGRect {
        let w = widthInUserInterfaceDimensionUnit
        let h = heightInUserInterfaceDimensionUnit
        let px = xInUserInterfaceDimensionUnit - w / 2
        let py = yInUserInterfaceDimensionUnit - h / 2
        let vertices: [Float]
        if rotation == 0 {
            vertices = [px, py, px, py + h, px + w, py + h, px + w, py]
        } else {
            let center = CGPoint(x: CGFloat(px + w / 2), y: CGFloat(py + h / 2))
            let ul = rotatePointAroundPoint(center: center, point: CGPoint(x: CGFloat(px), y: CGFloat(py)), rotation: rotation)
            let ur = rotatePointAroundPoint(center: center, point: CGPoint(x: CGFloat(px), y: CGFloat(py + h)), rotation: rotation)
            let lr = rotatePointAroundPoint(center: center, point: CGPoint(x: CGFloat(px + w), y: CGFloat(py + h)), rotation: rotation)
            let ll = rotatePointAroundPoint(center: center, point: CGPoint(x: CGFloat(px + w), y: CGFloat(py)), rotation: rotation)
            vertices = [Float(ul.x), Float(ul.y), Float(ur.x), Float(ur.y),
                        Float(lr.x), Float(lr.y), Float(ll.x), Float(ll.y)]
        }
        return Polygon(vertices).getBoundingRectangle()
    }

    public func getCurrentCollisionPolygon() -> [Polygon] {
        var original: [Polygon] = []
        if let lookData = lookData {
            let info = lookData.collisionInformation
            if info.collisionPolygons == nil { info.loadCollisionPolygon() }
            original = info.collisionPolygons ?? []
        }
        return original.map { src in
            let poly = Polygon(src.getTransformedVertices())
            poly.translate(x, y)
            poly.setRotation(rotation)
            poly.setScale(scaleX, scaleY)
            poly.setOrigin(originX, originY)
            return poly
        }
    }
}

/// Замена InputEvent: касание, переданное нижележащему актёру.
public final class TouchEvent: Event {
    public let stageX: Float, stageY: Float, pointer: Int
    init(stageX: Float, stageY: Float, pointer: Int) {
        self.stageX = stageX; self.stageY = stageY; self.pointer = pointer
        super.init()
    }
}
