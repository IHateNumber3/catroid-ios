import Foundation

open class DronePlayLedAnimationBrick: BrickBaseType {
    public var ledAnimationName: String = ""

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
    }

    open override func copyState(from other: BrickBaseType) {
        super.copyState(from: other)
        if let o = other as? DronePlayLedAnimationBrick {
            ledAnimationName = o.ledAnimationName
        }
    }
}
