import Foundation

public enum Operators: String {
    case logicalAnd = "LOGICAL_AND", logicalOr = "LOGICAL_OR", equal = "EQUAL", notEqual = "NOT_EQUAL"
    case smallerOrEqual = "SMALLER_OR_EQUAL", greaterOrEqual = "GREATER_OR_EQUAL"
    case smallerThan = "SMALLER_THAN", greaterThan = "GREATER_THAN"
    case plus = "PLUS", minus = "MINUS", mult = "MULT", divide = "DIVIDE", mod = "MOD", pow = "POW"
    case logicalNot = "LOGICAL_NOT"

    private var priority: Int {
        switch self {
        case .logicalOr: return 1
        case .logicalAnd: return 2
        case .equal: return 3
        case .notEqual, .smallerOrEqual, .greaterOrEqual, .smallerThan, .greaterThan, .logicalNot: return 4
        case .plus, .minus: return 5
        case .mult, .divide, .mod: return 6
        case .pow: return 7
        }
    }

    public var isLogicalOperator: Bool {
        switch self {
        case .logicalAnd, .logicalOr, .equal, .notEqual, .smallerOrEqual, .greaterOrEqual,
             .smallerThan, .greaterThan, .logicalNot: return true
        default: return false
        }
    }

    public func compareOperatorTo(_ other: Operators) -> Int {
        return priority < other.priority ? -1 : (priority == other.priority ? 0 : 1)
    }

    public static func getOperatorByValue(_ value: String?) -> Operators? { return value.flatMap { Operators(rawValue: $0) } }
    public static func isOperator(_ value: String) -> Bool { return Operators(rawValue: value) != nil }
}
