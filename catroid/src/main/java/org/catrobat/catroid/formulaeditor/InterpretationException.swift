import Foundation

public struct InterpretationException: Error, CustomStringConvertible {
    public let message: String
    public let underlying: Error?
    public init(_ message: String, underlying: Error? = nil) { self.message = message; self.underlying = underlying }
    public var description: String { return message }
}
