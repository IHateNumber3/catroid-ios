import Foundation

/// fun interface FormulaFunction { fun execute(vararg args: Double?): Any }
public typealias FormulaFunction = ([Double?]) -> Any

public func unaryFunction(_ action: @escaping (Double) -> Any) -> FormulaFunction {
    return { args in
        guard let a = args.first ?? nil else { return 0.0 }
        return action(a)
    }
}

public func binaryFunction(_ action: @escaping (Double, Double) -> Any) -> FormulaFunction {
    return { args in
        guard args.count > 1, let a = args[0], let b = args[1] else { return 0.0 }
        return action(a, b)
    }
}

public func ternaryFunction(_ action: @escaping (Double, Double, Double) -> Any) -> FormulaFunction {
    return { args in
        guard args.count > 2, let a = args[0], let b = args[1], let c = args[2] else { return 0.0 }
        return action(a, b, c)
    }
}

public protocol FunctionProvider {
    func addFunctions(to map: inout [Functions: FormulaFunction])
}
