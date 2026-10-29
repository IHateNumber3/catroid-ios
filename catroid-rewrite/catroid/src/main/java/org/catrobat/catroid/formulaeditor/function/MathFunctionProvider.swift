import Foundation

public struct MathFunctionProvider: FunctionProvider {
    public init() {}

    public func addFunctions(to m: inout [Functions: FormulaFunction]) {
        let rad = { (d: Double) in d * .pi / 180 }
        let deg = { (r: Double) in r * 180 / .pi }
        m[.sin] = unaryFunction { Foundation.sin(rad($0)) }
        m[.cos] = unaryFunction { Foundation.cos(rad($0)) }
        m[.tan] = unaryFunction { Foundation.tan(rad($0)) }
        m[.arctan2] = binaryFunction { a, b in
            if a == 0 && b == 0 { return Double.random(in: 0..<1) * 360 - 180 }
            return deg(Foundation.atan2(a, b))
        }
        m[.ln] = unaryFunction { Foundation.log($0) }
        m[.log] = unaryFunction { Foundation.log10($0) }
        m[.sqrt] = unaryFunction { $0.squareRoot() }
        m[.abs] = unaryFunction { Swift.abs($0) }
        m[.round] = unaryFunction { JavaCompat.round($0) }
        m[.pi] = { _ in Double.pi }
        m[.arcsin] = unaryFunction { deg(Foundation.asin($0)) }
        m[.arccos] = unaryFunction { deg(Foundation.acos($0)) }
        m[.arctan] = unaryFunction { deg(Foundation.atan($0)) }
        m[.exp] = unaryFunction { Foundation.exp($0) }
        m[.power] = binaryFunction { Foundation.pow($0, $1) }
        m[.floor] = unaryFunction { Foundation.floor($0) }
        m[.ceil] = unaryFunction { Foundation.ceil($0) }
        m[.max] = binaryFunction { a, b in (a.isNaN || b.isNaN) ? Double.nan : Swift.max(a, b) }
        m[.min] = binaryFunction { a, b in (a.isNaN || b.isNaN) ? Double.nan : Swift.min(a, b) }
        m[.trueFunction] = { _ in Conversions.TRUE }
        m[.falseFunction] = { _ in Conversions.FALSE }
        m[.mod] = binaryFunction { MathFunctionProvider.interpretFunctionMod($0, $1) }
    }

    static func interpretFunctionMod(_ dividendIn: Double, _ divisor: Double) -> Double {
        var dividend = dividendIn
        if dividend == 0 || divisor == 0 { return dividend }
        if divisor > 0 {
            while dividend < 0 { dividend += Swift.abs(divisor) }
        } else if dividend > 0 {
            return dividend.truncatingRemainder(dividingBy: divisor) + divisor
        }
        return dividend.truncatingRemainder(dividingBy: divisor)
    }
}
