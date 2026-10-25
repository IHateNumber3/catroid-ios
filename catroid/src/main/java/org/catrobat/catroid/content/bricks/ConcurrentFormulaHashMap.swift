import Foundation

/// ConcurrentHashMap<FormulaField, Formula>
public final class ConcurrentFormulaHashMap {
    private var storage: [FormulaField: Formula] = [:]
    private let lock = NSLock()

    public init() {}

    public subscript(key: FormulaField) -> Formula? {
        get { lock.lock(); defer { lock.unlock() }; return storage[key] }
        set { lock.lock(); defer { lock.unlock() }; storage[key] = newValue }
    }

    @discardableResult
    public func putIfAbsent(_ key: FormulaField, _ value: Formula) -> Formula? {
        lock.lock(); defer { lock.unlock() }
        if let existing = storage[key] { return existing }
        storage[key] = value
        return nil
    }

    @discardableResult
    public func replace(_ key: FormulaField, _ value: Formula) -> Formula? {
        lock.lock(); defer { lock.unlock() }
        guard let old = storage[key] else { return nil }
        storage[key] = value
        return old
    }

    @discardableResult
    public func remove(_ key: FormulaField) -> Formula? {
        lock.lock(); defer { lock.unlock() }
        return storage.removeValue(forKey: key)
    }

    public func get(_ key: FormulaField) -> Formula? { return self[key] }
    public func containsKey(_ key: FormulaField) -> Bool { return self[key] != nil }

    public var keys: [FormulaField] { lock.lock(); defer { lock.unlock() }; return Array(storage.keys) }
    public var values: [Formula] { lock.lock(); defer { lock.unlock() }; return Array(storage.values) }
    public var count: Int { lock.lock(); defer { lock.unlock() }; return storage.count }

    public func clone() -> ConcurrentFormulaHashMap {
        let copy = ConcurrentFormulaHashMap()
        for key in keys {
            if let v = self[key] { copy.putIfAbsent(key, v.clone()) }
        }
        return copy
    }
}
