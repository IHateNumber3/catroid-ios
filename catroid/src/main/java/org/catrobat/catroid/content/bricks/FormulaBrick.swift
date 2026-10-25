import Foundation

/// XML: поле formulaList (ConcurrentFormulaHashMap)
open class FormulaBrick: BrickBaseType {

    public internal(set) var formulaMap = ConcurrentFormulaHashMap()

    public required init() { super.init() }

    // MARK: Formula fields

    public func getFormulaWithBrickField(_ field: BrickField) -> Formula {
        if let f = formulaMap.get(field) { return f }
        preconditionFailure("Incompatible Brick Field: \(type(of: self)) does not have BrickField.\(field.rawValue)")
    }

    public func formulaWithBrickField(_ field: BrickField) -> Formula? { return formulaMap.get(field) }

    public func setFormulaWithBrickField(_ field: BrickField, _ formula: Formula) {
        if formulaMap.containsKey(field) {
            formulaMap.replace(field, formula)
        } else {
            preconditionFailure("Incompatible Brick Field: Cannot set BrickField.\(field.rawValue) for \(type(of: self))")
        }
    }

    public func addAllowedBrickField(_ field: BrickField) {
        formulaMap.putIfAbsent(field, Formula(0))
    }

    public func replaceFormulaBrickField(_ oldField: BrickField, _ newField: BrickField) {
        if let formula = formulaMap.get(oldField) {
            formulaMap.remove(oldField)
            formulaMap[newField] = formula
        }
    }

    open var formulas: [Formula] { return formulaMap.values }

    public var hasEditableFormulaField: Bool { return formulaMap.count > 0 }

    /// FormulaBrick.getDefaultBrickField: у Java — произвольный ключ; подклассы переопределяют
    open var defaultBrickField: BrickField {
        return (formulaMap.keys.first as? BrickField) ?? .xPosition
    }

    func isBrickFieldANumber(_ field: BrickField) -> Bool {
        return getFormulaWithBrickField(field).isNumber()
    }

    // MARK: Overrides

    open override func addRequiredResources(_ resourcesSet: ResourcesSet) {
        for formula in formulaMap.values { formula.addRequiredResources(resourcesSet) }
    }

    open override func copyState(from other: BrickBaseType) {
        super.copyState(from: other)
        if let o = other as? FormulaBrick { formulaMap = o.formulaMap.clone() }
    }

    open func updateUserDataReference(oldName: String, newName: String, item: UserData, renameAll: Bool) {
        for formula in formulas {
            if renameAll {
                formula.updateVariableName(oldName: oldName, newName: newName)
                formula.updateUserlistName(oldName: oldName, newName: newName)
            } else if item is UserVariable {
                formula.updateVariableName(oldName: oldName, newName: newName)
            } else {
                formula.updateUserlistName(oldName: oldName, newName: newName)
            }
        }
    }
}
