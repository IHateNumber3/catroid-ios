import Foundation

/// Java-совместимые числовые «методы» (Double.intValue() и т.д.), нужные транслированным actions.
public extension Double {
    var intValue: Int { return JavaCompat.int(self) }
    var floatValue: Float { return Float(self) }
}
public extension Float {
    var intValue: Int { return JavaCompat.int(Double(self)) }
    var doubleValue: Double { return Double(self) }
}
public extension Int {
    var floatValue: Float { return Float(self) }
    var doubleValue: Double { return Double(self) }
}
