import Foundation

/// Ключ формулы для входа пользовательского брика (реализация Brick.FormulaField).
public struct InputFormulaField: Hashable, CustomStringConvertible {
    public let input: String
    public init(_ input: String) { self.input = input }
    public var description: String { return input }
}
