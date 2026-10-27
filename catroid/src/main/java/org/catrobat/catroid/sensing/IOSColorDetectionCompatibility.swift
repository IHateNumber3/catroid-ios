import Foundation

/// Conservative iOS fallback for color sensing. Until pixel-buffer rendering
/// is connected, color-touch tests return false and colorAtXY returns NaN.
public final class ColorCollisionDetection {
    public init(scope: Scope, stageListener: StageListener?) {}
    public func tryInterpretFunctionTouchesColor(_ color: Any?) -> Bool { false }
    public func tryInterpretFunctionColorTouchesColor(_ spriteColor: Any?, _ stageColor: Any?) -> Bool { false }
}

public final class ColorAtXYDetection {
    public init(scope: Scope, stageListener: StageListener?) {}
    public func tryInterpretFunctionColorAtXY(_ x: Any?, _ y: Any?) -> String { Double.nan.description }
}

public final class ColorEqualsColor {
    public init() {}
    public func tryInterpretFunctionColorEqualsColor(_ first: Any?, _ second: Any?, _ tolerance: Any?) -> Bool {
        guard let a = first as? String, let b = second as? String else { return false }
        return a.trimmingCharacters(in: CharacterSet(charactersIn: "#")).uppercased() == b.trimmingCharacters(in: CharacterSet(charactersIn: "#")).uppercased()
    }
}
