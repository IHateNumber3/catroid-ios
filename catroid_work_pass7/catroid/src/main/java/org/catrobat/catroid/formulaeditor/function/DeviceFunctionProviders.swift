import Foundation

/// Touch: TouchUtil
public struct TouchFunctionProvider: FunctionProvider {
    public init() {}
    public func addFunctions(to m: inout [Functions: FormulaFunction]) {
        m[.multiFingerTouched] = unaryFunction { TouchUtil.isFingerTouching(JavaCompat.int($0)) ? 1.0 : 0.0 }
        m[.multiFingerX] = unaryFunction { Double(TouchUtil.getX(JavaCompat.int($0))) }
        m[.multiFingerY] = unaryFunction { Double(TouchUtil.getY(JavaCompat.int($0))) }
        m[.indexCurrentTouch] = unaryFunction { Double(TouchUtil.getIndexOfCurrentTouch(JavaCompat.int($0))) }
    }
}

/// Arduino (Bluetooth-сенсоры) — на iOS нет; возвращают 0 (как при отсутствии устройства).
public struct ArduinoFunctionProvider: FunctionProvider {
    public init() {}
    public func addFunctions(to m: inout [Functions: FormulaFunction]) {
        m[.arduinoanalog] = unaryFunction { _ in 0.0 }
        m[.arduinodigital] = unaryFunction { _ in 0.0 }
    }
}

/// Raspberry Pi (сокет) — заглушка.
public struct RaspiFunctionProvider: FunctionProvider {
    public init() {}
    public func addFunctions(to m: inout [Functions: FormulaFunction]) {
        m[.raspidigital] = unaryFunction { _ in 0.0 }
    }
}

/// Результаты детектора объектов (ML) — заполняются при подключении Vision/CoreML.
public enum ObjectDetectorResults {
    public static var result: [Int: Any] = [:]
}

public struct ObjectDetectorFunctionProvider: FunctionProvider {
    public init() {}
    public func addFunctions(to m: inout [Functions: FormulaFunction]) {
        m[.idOfDetectedObject] = unaryFunction { arg in
            let keys = Array(ObjectDetectorResults.result.keys)
            let i = JavaCompat.int(arg) - 1
            return keys.indices.contains(i) ? Double(keys[i]) : 0.0
        }
        m[.objectWithIdVisible] = unaryFunction { arg in ObjectDetectorResults.result[JavaCompat.int(arg)] != nil }
    }
}

/// Текстовые блоки с камеры (Vision) — пока пусто.
public final class TextBlockFunctionProvider: FunctionProvider {
    public init() {}
    public static var textBlocks: [String] = []
    public static var languages: [String] = []

    public func addFunctions(to m: inout [Functions: FormulaFunction]) {
        m[.textBlockX] = unaryFunction { _ in 0.0 }
        m[.textBlockY] = unaryFunction { _ in 0.0 }
        m[.textBlockSize] = unaryFunction { _ in 0.0 }
    }

    public func interpretFunctionTextBlock(_ index: Double) -> Any {
        let i = JavaCompat.int(index) - 1
        return Self.textBlocks.indices.contains(i) ? Self.textBlocks[i] : ""
    }

    public func interpretFunctionTextBlockLanguage(_ index: Double) -> Any {
        let i = JavaCompat.int(index) - 1
        return Self.languages.indices.contains(i) ? Self.languages[i] : ""
    }
}
