import Foundation

public final class FormulaElement {

    public enum ElementType: String {
        case `operator` = "OPERATOR", function = "FUNCTION", number = "NUMBER", sensor = "SENSOR"
        case userVariable = "USER_VARIABLE", userList = "USER_LIST", userDefinedBrickInput = "USER_DEFINED_BRICK_INPUT"
        case bracket = "BRACKET", string = "STRING", collisionFormula = "COLLISION_FORMULA"
    }

    public private(set) var type: ElementType
    private var value: String?
    public private(set) var leftChild: FormulaElement?
    public private(set) var rightChild: FormulaElement?
    public var additionalChildren: [FormulaElement?] = []
    public private(set) weak var parent: FormulaElement?

    private static let textBlockProvider = TextBlockFunctionProvider()
    private static let formulaFunctions: [Functions: FormulaFunction] = {
        var map: [Functions: FormulaFunction] = [:]
        let providers: [FunctionProvider] = [ArduinoFunctionProvider(), RaspiFunctionProvider(), MathFunctionProvider(),
                                             TouchFunctionProvider(), textBlockProvider, ObjectDetectorFunctionProvider()]
        providers.forEach { $0.addFunctions(to: &map) }
        return map
    }()

    // MARK: - Init

    public init(_ type: ElementType, _ value: String?, _ parent: FormulaElement?) {
        self.type = type
        self.value = value
        self.parent = parent
    }

    public convenience init(_ type: ElementType, _ value: String?, _ parent: FormulaElement?,
                            _ left: FormulaElement?, _ right: FormulaElement?) {
        self.init(type, value, parent)
        leftChild = left
        rightChild = right
        left?.parent = self
        right?.parent = self
    }

    public convenience init(_ type: ElementType, _ value: String?, _ parent: FormulaElement?,
                            _ left: FormulaElement?, _ right: FormulaElement?, _ additional: [FormulaElement?]) {
        self.init(type, value, parent, left, right)
        for child in additional { if let c = child { addAdditionalChild(c) } else { additionalChildren.append(nil) } }
    }

    // MARK: - Accessors

    public var elementType: ElementType { return type }
    public func getValue() -> String { return trimTrailingCharacters(value) }
    public var rawValue: String? { return value }
    public func setValue(_ v: String?) { value = v }

    public func getRoot() -> FormulaElement {
        var root = self
        while let p = root.parent { root = p }
        return root
    }
    public func getParent() -> FormulaElement? { return parent }

    public func setRightChild(_ c: FormulaElement) { rightChild = c; c.parent = self }
    public func setLeftChild(_ c: FormulaElement) { leftChild = c; c.parent = self }
    public func addAdditionalChild(_ c: FormulaElement) { additionalChildren.append(c); c.parent = self }

    // MARK: - Tree editing

    public func updateElementByName(_ oldName: String, _ newName: String, _ type: ElementType) {
        leftChild?.updateElementByName(oldName, newName, type)
        rightChild?.updateElementByName(oldName, newName, type)
        for c in additionalChildren { c?.updateElementByName(oldName, newName, type) }
        if matchesTypeAndName(type, oldName) { value = newName }
    }

    public func containsSpriteInCollision(_ name: String) -> Bool {
        if leftChild?.containsSpriteInCollision(name) == true || rightChild?.containsSpriteInCollision(name) == true { return true }
        for c in additionalChildren where c?.containsSpriteInCollision(name) == true { return true }
        return matchesTypeAndName(.collisionFormula, name)
    }

    public func insertFlattenForAllUserLists(_ element: FormulaElement, _ parent: FormulaElement?) {
        if let l = element.leftChild { insertFlattenForAllUserLists(l, element) }
        if let r = element.rightChild { insertFlattenForAllUserLists(r, element) }
        for c in element.additionalChildren { if let c = c { insertFlattenForAllUserLists(c, element) } }
        if element.type == .userList && isNotUserListFunction(parent) {
            insertFlattenBetweenParentAndElement(parent, element)
        }
    }

    public func isNotUserListFunction(_ element: FormulaElement?) -> Bool {
        guard let e = element, e.type == .function else { return true }
        let v = e.value ?? ""
        return ![Functions.contains, .numberOfItems, .listItem, .indexOfItem, .flatten].contains { $0.rawValue == v }
    }

    public func insertFlattenBetweenParentAndElement(_ parent: FormulaElement?, _ element: FormulaElement) {
        let flatten = FormulaElement(.function, Functions.flatten.rawValue, parent)
        insertElementBeforeChildInFormulaTree(parent, element, flatten)
    }

    private func insertElementBeforeChildInFormulaTree(_ parent: FormulaElement?, _ child: FormulaElement?, _ toInsert: FormulaElement?) {
        guard let child = child, let toInsert = toInsert else { return }
        child.parent = toInsert
        toInsert.setLeftChild(child)
        guard let parent = parent else { return }
        if parent.leftChild === child {
            parent.leftChild = toInsert
        } else if parent.rightChild === child {
            parent.rightChild = toInsert
        } else {
            for i in parent.additionalChildren.indices where parent.additionalChildren[i] === child {
                parent.additionalChildren[i] = toInsert
            }
        }
    }

    private func matchesTypeAndName(_ queried: ElementType, _ name: String) -> Bool {
        return type == queried && value == name
    }

    public func updateCollisionFormulaToVersion(_ project: Project) {
        leftChild?.updateCollisionFormulaToVersion(project)
        rightChild?.updateCollisionFormulaToVersion(project)
        for c in additionalChildren { c?.updateCollisionFormulaToVersion(project) }
        if type == .collisionFormula,
           let second = CollisionDetection.getSecondSpriteNameFromCollisionFormulaString(value, project) {
            value = second
        }
    }

    public func replaceElement(_ current: FormulaElement) {
        parent = current.parent
        leftChild = current.leftChild
        rightChild = current.rightChild
        for i in current.additionalChildren.indices {
            if i < additionalChildren.count { additionalChildren[i] = current.additionalChildren[i] }
            else { additionalChildren.append(current.additionalChildren[i]) }
        }
        value = current.value
        type = current.type
        leftChild?.parent = self
        rightChild?.parent = self
        for c in additionalChildren { c?.parent = self }
    }

    public func replaceElement(_ type: ElementType, _ value: String?) {
        self.value = value
        self.type = type
    }

    public func replaceWithSubElement(_ op: String, _ rightChild: FormulaElement) {
        let cloneThis = FormulaElement(.operator, op, parent, self, rightChild)
        cloneThis.parent?.rightChild = cloneThis
    }

    // MARK: - Interpretation

    public func interpretRecursive(_ scope: Scope) -> Any {
        return FormulaElementOperations.normalizeDegeneratedDoubleValues(rawInterpretRecursive(scope))
    }

    private func rawInterpretRecursive(_ scope: Scope) -> Any? {
        let pm = ProjectManager.shared
        let project = pm.currentProject
        let playingScene = pm.currentlyPlayingScene
        let editedScene = pm.currentlyEditedScene

        switch type {
        case .bracket:
            if let last = additionalChildren.last, let child = last { return child.interpretRecursive(scope) }
            return rightChild?.interpretRecursive(scope)
        case .number, .string:
            return value
        case .operator:
            guard let op = Operators.getOperatorByValue(value) else { return false }
            return interpretOperator(op, scope)
        case .function:
            return interpretFunction(Functions.getFunctionByValue(value), scope)
        case .sensor:
            guard let project = project else { return Conversions.FALSE }
            guard let editedScene = editedScene else { return Conversions.FALSE }
            return FormulaElementOperations.interpretSensor(scope.sprite, editedScene, project, value)
        case .userVariable:
            return FormulaElementOperations.interpretUserVariable(UserDataWrapper.getUserVariable(value ?? "", scope))
        case .userList:
            return FormulaElementOperations.interpretUserList(UserDataWrapper.getUserList(value ?? "", scope))
        case .userDefinedBrickInput:
            return FormulaElementOperations.interpretUserDefinedBrickInput(
                UserDataWrapper.getUserDefinedBrickInput(value ?? "", scope.sequence))
        case .collisionFormula:
            return FormulaElementOperations.tryInterpretCollision(scope.sprite.look, value, playingScene, StageActivity.stageListener)
        }
    }

    private func tryInterpretRecursive(_ e: FormulaElement?, _ scope: Scope) -> Any? {
        return e?.interpretRecursive(scope)
    }

    private func interpretFunction(_ function: Functions?, _ scope: Scope) -> Any? {
        guard let function = function else { return Conversions.FALSE }
        var arguments: [Any?] = [tryInterpretRecursive(leftChild, scope), tryInterpretRecursive(rightChild, scope)]
        for c in additionalChildren { arguments.append(tryInterpretRecursive(c, scope)) }
        func arg(_ i: Int) -> Any? { return i < arguments.count ? arguments[i] : nil }

        switch function {
        case .letter: return interpretFunctionLetter(arg(0), arg(1))
        case .subtext: return interpretFunctionSubtext(arg(0), arg(1), arg(2))
        case .length: return interpretFunctionLength(arg(0), scope)
        case .join: return Self.interpretFunctionString(leftChild, scope) + Self.interpretFunctionString(rightChild, scope)
        case .join3:
            return Self.interpretFunctionString(leftChild, scope) + Self.interpretFunctionString(rightChild, scope)
                + Self.interpretFunctionString(additionalChildren.first ?? nil, scope)
        case .regex: return tryInterpretFunctionRegex(scope)
        case .listItem: return interpretFunctionListItem(arg(0), scope)
        case .contains: return interpretFunctionContains(arg(1), scope)
        case .numberOfItems: return interpretFunctionNumberOfItems(arg(0), scope)
        case .indexOfItem: return interpretFunctionIndexOfItem(arg(0), scope)
        case .flatten: return Self.interpretFunctionString(leftChild, scope)
        case .collidesWithColor:
            return Conversions.booleanToDouble(ColorCollisionDetection(scope: scope, stageListener: StageActivity.stageListener)
                .tryInterpretFunctionTouchesColor(arg(0)))
        case .colorTouchesColor:
            return Conversions.booleanToDouble(ColorCollisionDetection(scope: scope, stageListener: StageActivity.stageListener)
                .tryInterpretFunctionColorTouchesColor(arg(0), arg(1)))
        case .colorAtXy:
            return ColorAtXYDetection(scope: scope, stageListener: StageActivity.stageListener)
                .tryInterpretFunctionColorAtXY(arg(0), arg(1))
        case .textBlockFromCamera:
            return Self.textBlockProvider.interpretFunctionTextBlock(JavaCompat.parseDouble(JavaCompat.string(arg(0))) ?? 0)
        case .textBlockLanguageFromCamera:
            return Self.textBlockProvider.interpretFunctionTextBlockLanguage(JavaCompat.parseDouble(JavaCompat.string(arg(0))) ?? 0)
        case .colorEqualsColor:
            return Conversions.booleanToDouble(ColorEqualsColor().tryInterpretFunctionColorEqualsColor(arg(0), arg(1), arg(2)))
        default:
            return interpretFormulaFunction(function, arguments)
        }
    }

    private func interpretFormulaFunction(_ function: Functions, _ arguments: [Any?]) -> Any {
        let doubles: [Double?] = arguments.map { Conversions.convertArgumentToDouble($0) }
        func d(_ i: Int) -> Double? { return i < doubles.count ? doubles[i] : nil }

        let fn: FormulaFunction
        switch function {
        case .rand: fn = binaryFunction { [self] a, b in interpretFunctionRand(a, b) }
        case .ifThenElse: fn = ternaryFunction { a, b, c in Self.interpretFunctionIfThenElse(a, b, c) }
        default:
            guard let f = Self.formulaFunctions[function] else { return Conversions.FALSE }
            fn = f
        }
        if doubles.count == 2 { return fn([d(0), d(1)]) }
        if doubles.count == 3, let cond = d(0), function == .ifThenElse {
            let thenPart: Any? = (arguments[1] is String) ? arguments[1] : d(1)
            let elsePart: Any? = (arguments[2] is String) ? arguments[2] : d(2)
            return Self.interpretFunctionIfThenElseObject(cond, thenPart, elsePart)
        }
        return fn([d(0), d(1), d(2)])
    }

    // MARK: lists

    private func interpretFunctionNumberOfItems(_ left: Any?, _ scope: Scope) -> Any {
        if leftChild?.type == .userList {
            let list = UserDataWrapper.getUserList(leftChild!.value ?? "", scope)
            return Double(list?.value.count ?? 0)
        }
        return interpretFunctionLength(left, scope)
    }

    private func getUserListOfChild(_ child: FormulaElement?, _ scope: Scope) -> UserList? {
        guard let child = child, child.type == .userList else { return nil }
        return UserDataWrapper.getUserList(child.value ?? "", scope)
    }

    private func interpretFunctionContains(_ right: Any?, _ scope: Scope) -> Any {
        guard let list = getUserListOfChild(leftChild, scope) else { return Conversions.FALSE }
        for item in list.value where FormulaElementOperations.interpretOperatorEqual(item, right ?? "") {
            return Conversions.TRUE
        }
        return Conversions.FALSE
    }

    private func interpretFunctionIndexOfItem(_ left: Any?, _ scope: Scope) -> Any {
        if rightChild?.type == .userList, let list = UserDataWrapper.getUserList(rightChild!.value ?? "", scope) {
            return Double(list.getIndexOf(left ?? "") + 1)
        }
        return Conversions.FALSE
    }

    private func interpretFunctionListItem(_ left: Any?, _ scope: Scope) -> Any {
        guard let left = left, let list = getUserListOfChild(rightChild, scope) else { return "" }
        let index = FormulaElementOperations.tryParseIntFromObject(left) - 1
        if index < 0 || index >= list.value.count { return "" }
        return list.value[index]
    }

    // MARK: strings

    private static func interpretFunctionString(_ child: FormulaElement?, _ scope: Scope) -> String {
        guard let child = child else { return "" }
        let interpretation = child.interpretRecursive(scope)
        switch child.type {
        case .string: return child.getValue()
        case .number: return formatNumberString(interpretation as? String ?? "")
        default: return trimTrailingCharacters(JavaCompat.string(interpretation))
        }
    }

    private static func formatNumberString(_ numberString: String) -> String {
        let number = JavaCompat.parseDouble(numberString) ?? Double.nan
        var formatted = ""
        if !number.isNaN {
            formatted = FormulaElementOperations.isInteger(number) ? String(JavaCompat.int(number)) : JavaCompat.double(number)
        }
        return trimTrailingCharacters(formatted)
    }

    private func tryInterpretFunctionRegex(_ scope: Scope) -> String {
        let pattern = Self.interpretFunctionString(leftChild, scope)
        let text = Self.interpretFunctionString(rightChild, scope)
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators, .anchorsMatchLines])
            guard let m = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) else { return "" }
            let group = m.numberOfRanges == 1 ? 0 : 1
            let r = m.range(at: group)
            guard r.location != NSNotFound, let range = Range(r, in: text) else { return "" }
            return String(text[range])
        } catch {
            return error.localizedDescription
        }
    }

    private func interpretFunctionLength(_ left: Any?, _ scope: Scope) -> Any {
        guard let leftChild = leftChild else { return Conversions.FALSE }
        switch leftChild.type {
        case .number, .string:
            return Double((leftChild.value ?? "").utf16.count)
        case .userVariable:
            return Double(calculateUserVariableLength(UserDataWrapper.getUserVariable(leftChild.value ?? "", scope)))
        case .userList:
            return calculateUserListLength(UserDataWrapper.getUserList(leftChild.value ?? "", scope), left, scope)
        default:
            if let d = left as? Double, d.isNaN { return 0.0 }
            return Double(JavaCompat.string(left).utf16.count)
        }
    }

    private func calculateUserVariableLength(_ variable: UserVariable?) -> Int {
        guard let v = variable?.value else { return 0 }
        if let s = v as? String { return s.utf16.count }
        if v is Bool { return 1 }
        if let d = v as? Double {
            if FormulaElementOperations.isInteger(d) { return String(JavaCompat.int(d)).count }
            return JavaCompat.double(d).count
        }
        return JavaCompat.string(v).count
    }

    private func calculateUserListLength(_ list: UserList?, _ left: Any?, _ scope: Scope) -> Double {
        guard let list = list, !list.value.isEmpty else { return Conversions.FALSE }
        let interpreted = leftChild?.interpretRecursive(scope)
        if let d = interpreted as? Double {
            if d.isNaN || d.isInfinite { return Conversions.FALSE }
            return Double(String(JavaCompat.int(d)).count)
        }
        if let s = interpreted as? String { return Double(s.utf16.count) }
        if let d = left as? Double, d.isNaN { return Conversions.FALSE }
        return Double(JavaCompat.string(left).utf16.count)
    }

    private func interpretFunctionLetter(_ left: Any?, _ right: Any?) -> Any {
        guard let left = left, let right = right else { return "" }
        let index = FormulaElementOperations.tryParseIntFromObject(left) - 1
        let s = JavaCompat.string(right) as NSString
        if index < 0 || index >= s.length { return "" }
        return s.substring(with: NSRange(location: index, length: 1))
    }

    private func interpretFunctionSubtext(_ left: Any?, _ right: Any?, _ string: Any?) -> Any {
        guard let left = left, let right = right else { return "" }
        let start = FormulaElementOperations.tryParseIntFromObject(left) - 1
        let end = FormulaElementOperations.tryParseIntFromObject(right)
        let s = JavaCompat.string(string) as NSString
        if start < 0 || end < 0 || start > end || end > s.length { return "" }
        return s.substring(with: NSRange(location: start, length: end - start))
    }

    // MARK: math helpers

    private static func isNumberWithDecimalPoint(_ e: FormulaElement?) -> Bool {
        guard let e = e else { return false }
        return e.type == .number && (e.value ?? "").contains(".")
    }

    private func interpretFunctionRand(_ from: Double, _ to: Double) -> Double {
        let low = min(from, to), high = max(from, to)
        if low == high { return low }
        let intOnly = FormulaElementOperations.isInteger(low) && FormulaElementOperations.isInteger(high)
            && !Self.isNumberWithDecimalPoint(leftChild) && !Self.isNumberWithDecimalPoint(rightChild)
        if intOnly { return floor(Double.random(in: 0..<1) * ((high + 1) - low)) + low }
        return Double.random(in: 0..<1) * (high - low) + low
    }

    private static func interpretFunctionIfThenElse(_ c: Double, _ t: Double, _ e: Double) -> Double {
        if c.isNaN { return Double.nan }
        return c != 0 ? t : e
    }

    private static func interpretFunctionIfThenElseObject(_ c: Double, _ t: Any?, _ e: Any?) -> Any {
        if c.isNaN { return Double.nan }
        return (c != 0 ? t : e) ?? 0.0
    }

    // MARK: operators

    private func interpretOperator(_ op: Operators, _ scope: Scope) -> Double {
        return leftChild != nil ? interpretBinaryOperator(op, scope) : interpretUnaryOperator(op, scope)
    }

    private func interpretUnaryOperator(_ op: Operators, _ scope: Scope) -> Double {
        guard let rc = rightChild else { return Conversions.FALSE }
        let right = FormulaElementOperations.tryInterpretDoubleValue(FormulaElementOperations.tryInterpretElementRecursive(rc, scope))
        switch op {
        case .minus: return -right
        case .logicalNot: return Conversions.booleanToDouble(right == Conversions.FALSE)
        default: return Conversions.FALSE
        }
    }

    /// BigDecimal.valueOf(d) + DECIMAL128: через Foundation.Decimal по кратчайшей десятичной записи.
    private static func decimal(_ d: Double) -> Decimal? {
        if d == 0 { return Decimal(0) }
        if abs(d) >= 1e100 || abs(d) < 1e-100 { return nil }
        return Decimal(string: "\(d)", locale: Locale(identifier: "en_US_POSIX"))
    }

    private static func arith(_ l: Double, _ r: Double, _ op: (Decimal, Decimal) -> Decimal, _ fallback: (Double, Double) -> Double) -> Double {
        if let a = decimal(l), let b = decimal(r) {
            return NSDecimalNumber(decimal: op(a, b)).doubleValue
        }
        return fallback(l, r)
    }

    private func interpretBinaryOperator(_ op: Operators, _ scope: Scope) -> Double {
        guard let lc = leftChild, let rc = rightChild else { return Conversions.FALSE }
        let leftObject = FormulaElementOperations.tryInterpretElementRecursive(lc, scope)
        let rightObject = FormulaElementOperations.tryInterpretElementRecursive(rc, scope)
        let leftDouble = FormulaElementOperations.tryInterpretDoubleValue(leftObject)
        let rightDouble = FormulaElementOperations.tryInterpretDoubleValue(rightObject)
        // BigDecimal.valueOf(NaN/Infinity) бросает исключение → 0
        let l = leftDouble.isFinite ? leftDouble : 0
        let r = rightDouble.isFinite ? rightDouble : 0
        let nan = leftDouble.isNaN || rightDouble.isNaN

        switch op {
        case .plus: return nan ? Double.nan : Self.arith(l, r, { $0 + $1 }, { $0 + $1 })
        case .minus: return nan ? Double.nan : Self.arith(l, r, { $0 - $1 }, { $0 - $1 })
        case .mult: return nan ? Double.nan : Self.arith(l, r, { $0 * $1 }, { $0 * $1 })
        case .divide:
            if nan || r == 0 { return Double.nan }
            return Self.arith(l, r, { $0 / $1 }, { $0 / $1 })
        case .pow: return nan ? Double.nan : Foundation.pow(l, r)
        case .equal: return Conversions.booleanToDouble(FormulaElementOperations.interpretOperatorEqual(leftObject, rightObject))
        case .notEqual: return Conversions.booleanToDouble(!FormulaElementOperations.interpretOperatorEqual(leftObject, rightObject))
        case .greaterThan: return Conversions.booleanToDouble(JavaCompat.compare(leftDouble, rightDouble) > 0)
        case .greaterOrEqual: return Conversions.booleanToDouble(JavaCompat.compare(leftDouble, rightDouble) >= 0)
        case .smallerThan: return Conversions.booleanToDouble(JavaCompat.compare(leftDouble, rightDouble) < 0)
        case .smallerOrEqual: return Conversions.booleanToDouble(JavaCompat.compare(leftDouble, rightDouble) <= 0)
        case .logicalAnd: return Conversions.booleanToDouble(leftDouble != Conversions.FALSE && rightDouble != Conversions.FALSE)
        case .logicalOr: return Conversions.booleanToDouble(leftDouble != Conversions.FALSE || rightDouble != Conversions.FALSE)
        default: return Conversions.FALSE
        }
    }

    // MARK: - Queries

    public func isBoolean(_ scope: Scope) -> Bool {
        switch type {
        case .userVariable:
            return UserDataWrapper.getUserVariable(value ?? "", scope)?.value is Bool
        case .userList:
            let values = UserDataWrapper.getUserList(value ?? "", scope)?.value ?? []
            return values.count == 1 && values[0] is Bool
        case .userDefinedBrickInput:
            if let data = UserDataWrapper.getUserDefinedBrickInput(value ?? "", scope.sequence),
               let v = data as? UserVariable, let formula = v.value as? Formula {
                return formula.root?.isBoolean(scope) ?? false
            }
            return false
        default:
            return isOtherBooleanFormulaElement()
        }
    }

    private func isOtherBooleanFormulaElement() -> Bool {
        switch type {
        case .function: return Functions.getFunctionByValue(value).map { Functions.isBoolean($0) } ?? false
        case .sensor: return Sensors.getSensorByValue(value).map { Sensors.isBoolean($0) } ?? false
        case .operator: return Operators.getOperatorByValue(value)?.isLogicalOperator ?? false
        case .collisionFormula: return true
        default: return false
        }
    }

    public func containsElement(_ elementType: ElementType) -> Bool {
        if type == elementType || leftChild?.containsElement(elementType) == true || rightChild?.containsElement(elementType) == true {
            return true
        }
        for c in additionalChildren where c?.containsElement(elementType) == true { return true }
        return false
    }

    public func isNumber() -> Bool {
        if type == .operator {
            return Operators.getOperatorByValue(value) == .minus && leftChild == nil && (rightChild?.isNumber() ?? false)
        }
        return type == .number
    }

    public func clone() -> FormulaElement {
        let additional = additionalChildren.map { $0?.clone() }
        return FormulaElement(type, value ?? "", nil, leftChild?.clone(), rightChild?.clone(), additional)
    }

    public func addRequiredResources(_ resources: ResourcesSet) {
        leftChild?.addRequiredResources(resources)
        rightChild?.addRequiredResources(resources)
        for c in additionalChildren { c?.addRequiredResources(resources) }
        switch type {
        case .function: FormulaElementResources.addFunctionResources(resources, Functions.getFunctionByValue(value))
        case .sensor: FormulaElementResources.addSensorsResources(resources, Sensors.getSensorByValue(value))
        case .collisionFormula: resources.add(.collision)
        default: break
        }
    }

    public func getUserDataRecursive(_ type: ElementType) -> [String] {
        var names: [String] = []
        if self.type == type { names.append(value ?? "") }
        names += leftChild?.getUserDataRecursive(type) ?? []
        names += rightChild?.getUserDataRecursive(type) ?? []
        for c in additionalChildren { names += c?.getUserDataRecursive(type) ?? [] }
        return names
    }
}
