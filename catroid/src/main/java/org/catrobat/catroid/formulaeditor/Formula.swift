import Foundation

public protocol FormulaStringProvider {
    func getTrueOrFalse(_ value: Bool) -> String
}

/// Равенство/хеш — по ссылке (в Java Formula не переопределяет equals).
public final class Formula: Hashable {

    private static let errorString = "ERROR"

    private var formulaTree: FormulaElement!
    private var sceneFirstStart = false

    // MARK: - Init

    public init(_ element: FormulaElement) {
        formulaTree = element
    }

    public convenience init(_ value: Int) {
        self.init(FormulaElement(.number, "0", nil))   // перезапишется ниже
        if value < 0 {
            initInverted(String(abs(Int64(value))))
        } else {
            formulaTree = FormulaElement(.number, String(value), nil)
        }
    }

    public convenience init(_ value: Double) {
        self.init(FormulaElement(.number, "0", nil))
        if value < 0 {
            initInverted(JavaCompat.double(abs(value)))
        } else {
            formulaTree = FormulaElement(.number, JavaCompat.double(value), nil)
        }
    }

    public convenience init(_ value: Float) {
        self.init(Double(value))
    }

    public convenience init(_ value: String) {
        let arduinoAnalog = Functions.arduinoanalog.rawValue
        let arduinoDigital = Functions.arduinodigital.rawValue
        if value.caseInsensitiveCompare(arduinoAnalog) == .orderedSame {
            self.init(FormulaElement(.sensor, arduinoAnalog, nil))
        } else if value.caseInsensitiveCompare(arduinoDigital) == .orderedSame {
            self.init(FormulaElement(.sensor, arduinoDigital, nil))
        } else {
            self.init(FormulaElement(.string, value, nil))
        }
    }

    private func initInverted(_ value: String) {
        formulaTree = FormulaElement(.operator, Operators.minus.rawValue, nil)
        formulaTree.setRightChild(FormulaElement(.number, value, formulaTree))
    }

    // MARK: - Tree

    public var root: FormulaElement? { return formulaTree }
    public func getRoot() -> FormulaElement { return formulaTree }
    public func getFormulaTree() -> FormulaElement { return formulaTree }
    public func setRoot(_ element: FormulaElement) { formulaTree = element }

    // Редакторское представление (InternFormula) строится из дерева при открытии редактора,
    // поэтому здесь обновляется только дерево.
    public func updateCollisionFormulas(oldName: String, newName: String) {
        formulaTree.updateElementByName(oldName, newName, .collisionFormula)
    }

    public func flattenAllLists() {
        formulaTree.insertFlattenForAllUserLists(formulaTree, nil)
        formulaTree = formulaTree.getRoot()
    }

    public func updateCollisionFormulasToVersion() {
        if let project = ProjectManager.shared.currentProject {
            formulaTree.updateCollisionFormulaToVersion(project)
        }
    }

    public func updateDirectionPropertyToVersion() {
        formulaTree.updateElementByName("OBJECT_ROTATION", "MOTION_DIRECTION", .sensor)
    }

    public func updateVariableName(oldName: String, newName: String) {
        formulaTree.updateElementByName(oldName, newName, .userVariable)
    }

    public func updateUserlistName(oldName: String, newName: String) {
        formulaTree.updateElementByName(oldName, newName, .userList)
    }

    public func containsSpriteInCollision(_ name: String) -> Bool { return formulaTree.containsSpriteInCollision(name) }
    public func containsElement(_ type: FormulaElement.ElementType) -> Bool { return formulaTree.containsElement(type) }
    public func isNumber() -> Bool { return formulaTree.isNumber() }

    // MARK: - Interpretation

    public func interpretInteger(_ scope: Scope) throws -> Int {
        return JavaCompat.int(try interpretDouble(scope))
    }

    public func interpretDouble(_ scope: Scope) throws -> Double {
        if sceneFirstStart {
            sceneFirstStart = false
            return 0.0
        }
        let value = try interpretDoubleInternal(scope)
        if value.isNaN { throw InterpretationException("NaN in interpretDouble()") }
        return value
    }

    private func interpretDoubleInternal(_ scope: Scope) throws -> Double {
        let o = formulaTree.interpretRecursive(scope)
        if let s = o as? String {
            guard let d = JavaCompat.parseDouble(s) else {
                throw InterpretationException("Couldn't interpret Formula.")
            }
            return d
        }
        guard let d = o as? Double else { throw InterpretationException("Couldn't interpret Formula.") }
        return d
    }

    public func interpretFloat(_ scope: Scope) throws -> Float { return Float(try interpretDouble(scope)) }

    public func interpretString(_ scope: Scope) throws -> String {
        let interpretation = formulaTree.interpretRecursive(scope)
        if let d = interpretation as? Double, d.isNaN { throw InterpretationException("NaN in interpretString()") }
        return trimTrailingCharacters(JavaCompat.string(interpretation))
    }

    public func interpretObject(_ scope: Scope) -> Any { return formulaTree.interpretRecursive(scope) }

    public func interpretBoolean(_ scope: Scope) throws -> Bool {
        return JavaCompat.int(try interpretDouble(scope)) != 0
    }

    public func interpretBooleanToString(_ scope: Scope, _ provider: FormulaStringProvider) throws -> String {
        return provider.getTrueOrFalse(try interpretBoolean(scope))
    }

    public func getUserFriendlyString(_ provider: FormulaStringProvider, _ scope: Scope) -> String {
        if formulaTree.isBoolean(scope) {
            return (try? interpretBooleanToString(scope, provider)) ?? Self.errorString
        }
        return (try? interpretString(scope)) ?? Self.errorString
    }

    public func sceneFirstStart(_ value: Bool) { sceneFirstStart = value }

    // MARK: - Clone / resources

    public func clone() -> Formula {
        if let tree = formulaTree { return Formula(tree.clone()) }
        return Formula(0)
    }

    public func addRequiredResources(_ resources: ResourcesSet) {
        formulaTree.addRequiredResources(resources)
    }

    // MARK: - Hashable

    public static func == (l: Formula, r: Formula) -> Bool { return l === r }
    public func hash(into hasher: inout Hasher) { hasher.combine(ObjectIdentifier(self)) }
}
