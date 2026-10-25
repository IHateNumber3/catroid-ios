import Foundation

/// XML: <userDefinedBrickLabel><label/></userDefinedBrickLabel>
public final class UserDefinedBrickLabel: UserDefinedBrickData, Equatable, Hashable {
    public let label: String

    public init(_ label: String) {
        self.label = label
        super.init(type: .label)
    }

    public convenience init(copying other: UserDefinedBrickLabel) {
        self.init(other.label)
    }

    public override var dataName: String { return label }

    public static func == (l: UserDefinedBrickLabel, r: UserDefinedBrickLabel) -> Bool { return l.label == r.label }
    public func hash(into hasher: inout Hasher) { hasher.combine(label) }
}
