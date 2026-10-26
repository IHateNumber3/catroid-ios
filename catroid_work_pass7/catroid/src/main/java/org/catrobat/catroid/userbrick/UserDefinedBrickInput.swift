import Foundation

/// XML: <userDefinedBrickInput><input/></userDefinedBrickInput>
public final class UserDefinedBrickInput: UserDefinedBrickData, UserData {

    public private(set) var inputName: InputFormulaField
    private var valueStorage: Formula?
    public var initialIndex = -1

    public init(_ input: String) {
        inputName = InputFormulaField(input)
        valueStorage = Formula(0)
        super.init(type: .input)
    }

    public convenience init(copying other: UserDefinedBrickInput) {
        self.init(other.inputName.input)
        valueStorage = other.valueStorage
    }

    // Nameable
    public var name: String {
        get { return inputName.description }
        set { /* имя входа не меняется (как в Java) */ }
    }
    public override var dataName: String { return inputName.description }

    public var inputFormulaField: InputFormulaField { return inputName }

    public var value: Formula {
        get {
            if valueStorage == nil { valueStorage = Formula(0) }
            return valueStorage!
        }
        set { valueStorage = newValue }
    }
    public func getValue() -> Formula { return value }
    public func setValue(_ v: Formula) { value = v }

    public func reset() { valueStorage = Formula(0) }

    public var deviceKey: UUID { return UUID.nameUUIDFromBytes(Data(inputName.description.utf8)) }
}
