import Foundation

public class ViewSwitchLock {
    
    private static let unlockTimeout: TimeInterval = 0.2 // 200 миллисекунд
    private static let tag = "ViewSwitchLock"
    
    private var locked = false
    private let lockQueue = DispatchQueue(label: "org.catrobat.catroid.ui.ViewSwitchLock", attributes: .concurrent)
    
    public init() {}
    
    /// Пытается заблокировать действие на короткий таймаут (эквивалент tryLock)
    public func tryLock() -> Bool {
        return lockQueue.sync(flags: .barrier) {
            if locked {
                return false
            }
            
            locked = true
            
            // Автоматическое снятие блокировки через 200 мс
            DispatchQueue.global().asyncAfter(deadline: .now() + ViewSwitchLock.unlockTimeout) { [weak self] {
                self?.unlock()
            } }
            
            return true
        }
    }
    
    public func unlock() {
        lockQueue.async(flags: .barrier) { [weak self] in
            self?.locked = false
        }
    }
}
