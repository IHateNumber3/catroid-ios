import Foundation
import CoreGraphics

public enum TouchUtil {
    private static var pointerToTouchIndex: [Int: Int] = [:]
    private static var touches: [CGPoint] = []
    private static var touching: [Bool] = []

    public static func reset() {
        pointerToTouchIndex.removeAll()
        touches.removeAll()
        touching.removeAll()
    }

    public static func updatePosition(x: Float, y: Float, pointer: Int) {
        guard let index = pointerToTouchIndex[pointer] else { return }
        touches[index] = CGPoint(x: CGFloat(x), y: CGFloat(y))
    }

    public static func touchDown(x: Float, y: Float, pointer: Int) {
        if pointerToTouchIndex[pointer] != nil { return }
        pointerToTouchIndex[pointer] = touches.count
        touches.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
        touching.append(true)
        fireTouchEvent()
    }

    public static func touchUp(pointer: Int) {
        guard let index = pointerToTouchIndex[pointer] else { return }
        touching[index] = false
        pointerToTouchIndex.removeValue(forKey: pointer)
    }

    public static func isTouching() -> Double {
        return touching.contains(true) ? 1.0 : 0.0
    }

    public static func isFingerTouching(_ index: Int) -> Bool {
        if index < 1 || index > touching.count { return false }
        return touching[index - 1]
    }

    public static var lastTouchIndex: Int { return touches.count }

    public static func getX(_ index: Int) -> Float {
        if index < 1 || index > touching.count { return 0 }
        return Float(touches[index - 1].x)
    }

    public static func getY(_ index: Int) -> Float {
        if index < 1 || index > touching.count { return 0 }
        return Float(touches[index - 1].y)
    }

    public static func setDummyTouchForTest(x: Float, y: Float) {
        touches.append(CGPoint(x: CGFloat(x), y: CGFloat(y)))
        touching.append(false)
    }

    private static func fireTouchEvent() {
        let event = EventWrapper(eventId: EventId(EventId.tapBackground), waitForCompletion: false)
        ProjectManager.shared.currentProject?.fireToAllSprites(event)
    }

    /// Порядок как у SparseIntArray: по возрастанию ключа (pointer)
    public static func getCurrentTouchingPoints() -> [CGPoint] {
        return pointerToTouchIndex.keys.sorted().map { touches[pointerToTouchIndex[$0]!] }
    }

    public static var numberOfCurrentTouches: Int { return pointerToTouchIndex.count }

    public static func getIndexOfCurrentTouch(_ index: Int) -> Int {
        if index < 1 || index > pointerToTouchIndex.count { return 0 }
        let key = pointerToTouchIndex.keys.sorted()[index - 1]
        return pointerToTouchIndex[key]! + 1
    }
}
