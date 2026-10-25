import Foundation

/// XML: userDefinedBrickDataList, userDefinedBrickID, callingBrick
open class UserDefinedBrick: FormulaBrick {

    public private(set) var userDefinedBrickDataList: [UserDefinedBrickData] = []
    public private(set) var userDefinedBrickID = UUID()
    public private(set) var isCallingBrick = false

    public required init() { super.init() }

    public convenience init(_ dataList: [UserDefinedBrickData]) {
        self.init()
        userDefinedBrickDataList = dataList
    }

    public convenience init(copying other: UserDefinedBrick) {
        self.init()
        copyUserDefinedDataList(other)
        userDefinedBrickID = other.userDefinedBrickID
        isCallingBrick = other.isCallingBrick
    }

    open override func copyState(from other: BrickBaseType) {
        super.copyState(from: other)
        if let o = other as? UserDefinedBrick {
            userDefinedBrickDataList = o.userDefinedBrickDataList
            userDefinedBrickID = o.userDefinedBrickID
            isCallingBrick = o.isCallingBrick
        }
    }

    private func copyUserDefinedDataList(_ brick: UserDefinedBrick) {
        userDefinedBrickDataList = []
        for data in brick.userDefinedBrickDataList {
            if let oldInput = data as? UserDefinedBrickInput {
                let newInput = UserDefinedBrickInput(copying: oldInput)
                userDefinedBrickDataList.append(newInput)
                if brick.isCallingBrick { copyFormulaOfInput(oldInput, newInput) }
            } else if let label = data as? UserDefinedBrickLabel {
                userDefinedBrickDataList.append(UserDefinedBrickLabel(copying: label))
            }
        }
    }

    private func copyFormulaOfInput(_ oldInput: UserDefinedBrickInput, _ newInput: UserDefinedBrickInput) {
        let formula = formulaMap.get(oldInput.inputFormulaField)
        formulaMap.remove(oldInput.inputFormulaField)
        if let f = formula { formulaMap.putIfAbsent(newInput.inputFormulaField, f) }
    }

    public func setCallingBrick(_ callingBrick: Bool) { isCallingBrick = callingBrick }

    /// В Java поля формул создаёт getView(); для не-UI контекстов — явно
    public func ensureInputFormulaFields() {
        for input in getUserDefinedBrickInputs() { addAllowedBrickField(input.inputFormulaField) }
    }

    public func addLabel(_ label: String) {
        removeLastLabel()
        userDefinedBrickDataList.append(UserDefinedBrickLabel(label))
    }

    public func removeLastLabel() {
        if lastContentIsLabel() { userDefinedBrickDataList.removeLast() }
    }

    public func addInput(_ input: String) {
        userDefinedBrickDataList.append(UserDefinedBrickInput(input))
    }

    public var isEmpty: Bool { return userDefinedBrickDataList.isEmpty }

    public func getUserDefinedBrickInputs() -> [UserDefinedBrickInput] {
        return userDefinedBrickDataList.compactMap { $0 as? UserDefinedBrickInput }
    }

    public func containsInputs() -> Bool { return userDefinedBrickDataList.contains { $0.isInput } }

    public func getUserDataListAsStrings(_ dataType: UserDefinedBrickDataType) -> [String] {
        return userDefinedBrickDataList.filter { $0.type == dataType }.map { $0.dataName }
    }

    private func lastContentIsLabel() -> Bool {
        return userDefinedBrickDataList.last?.isLabel ?? false
    }

    public func isUserDefinedBrickDataEqual(_ brick: Brick) -> Bool {
        guard let other = brick as? UserDefinedBrick,
              userDefinedBrickDataList.count == other.userDefinedBrickDataList.count else { return false }
        for (a, b) in zip(userDefinedBrickDataList, other.userDefinedBrickDataList) {
            if type(of: a) != type(of: b) { return false }
            if let la = a as? UserDefinedBrickLabel, let lb = b as? UserDefinedBrickLabel, la != lb { return false }
        }
        return true
    }

    private func updateUserDefinedBrickDataValues() {
        for input in getUserDefinedBrickInputs() {
            input.setValue(getFormulaWithBrickField(input.inputFormulaField))
        }
    }

    open override var hasEditableFormulaField: Bool { return containsInputs() }

    open override func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction) {
        updateUserDefinedBrickDataValues()
        sequence.addAction(sprite.actionFactory.createUserBrickAction(sprite, sequence, getUserDefinedBrickInputs(), userDefinedBrickID))
    }
}
