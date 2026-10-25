import Foundation

/// rawValue = имя константы в Java (так хранится в XML)
public enum Functions: String, CaseIterable {
    case sin = "SIN"
    case cos = "COS"
    case tan = "TAN"
    case ln = "LN"
    case log = "LOG"
    case sqrt = "SQRT"
    case rand = "RAND"
    case round = "ROUND"
    case abs = "ABS"
    case pi = "PI"
    case mod = "MOD"
    case arcsin = "ARCSIN"
    case arccos = "ARCCOS"
    case arctan = "ARCTAN"
    case arctan2 = "ARCTAN2"
    case exp = "EXP"
    case power = "POWER"
    case floor = "FLOOR"
    case ceil = "CEIL"
    case max = "MAX"
    case min = "MIN"
    case trueFunction = "TRUE"
    case falseFunction = "FALSE"
    case length = "LENGTH"
    case letter = "LETTER"
    case subtext = "SUBTEXT"
    case join = "JOIN"
    case join3 = "JOIN3"
    case regex = "REGEX"
    case listItem = "LIST_ITEM"
    case contains = "CONTAINS"
    case indexOfItem = "INDEX_OF_ITEM"
    case numberOfItems = "NUMBER_OF_ITEMS"
    case arduinoanalog = "ARDUINOANALOG"
    case arduinodigital = "ARDUINODIGITAL"
    case raspidigital = "RASPIDIGITAL"
    case multiFingerX = "MULTI_FINGER_X"
    case multiFingerY = "MULTI_FINGER_Y"
    case multiFingerTouched = "MULTI_FINGER_TOUCHED"
    case indexCurrentTouch = "INDEX_CURRENT_TOUCH"
    case collidesWithColor = "COLLIDES_WITH_COLOR"
    case colorTouchesColor = "COLOR_TOUCHES_COLOR"
    case colorAtXy = "COLOR_AT_XY"
    case colorEqualsColor = "COLOR_EQUALS_COLOR"
    case textBlockX = "TEXT_BLOCK_X"
    case textBlockY = "TEXT_BLOCK_Y"
    case textBlockSize = "TEXT_BLOCK_SIZE"
    case textBlockFromCamera = "TEXT_BLOCK_FROM_CAMERA"
    case textBlockLanguageFromCamera = "TEXT_BLOCK_LANGUAGE_FROM_CAMERA"
    case ifThenElse = "IF_THEN_ELSE"
    case flatten = "FLATTEN"
    case idOfDetectedObject = "ID_OF_DETECTED_OBJECT"
    case objectWithIdVisible = "OBJECT_WITH_ID_VISIBLE"

    public static let text: Set<Functions> = [.length, .letter, .subtext, .join, .join3, .regex]
    public static let list: Set<Functions> = [.listItem, .contains, .indexOfItem, .numberOfItems, .flatten]
    public static let boolean: Set<Functions> = [.trueFunction, .falseFunction, .contains, .multiFingerTouched, .collidesWithColor, .colorTouchesColor, .colorEqualsColor]

    public static func isFunction(_ value: String) -> Bool { return Functions(rawValue: value) != nil }
    public static func isBoolean(_ f: Functions) -> Bool { return boolean.contains(f) }
    public static func getFunctionByValue(_ value: String?) -> Functions? { return value.flatMap { Functions(rawValue: $0) } }
}
