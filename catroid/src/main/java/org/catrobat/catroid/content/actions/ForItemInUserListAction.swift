import Foundation

open class ForItemInUserListAction: LoopAction {
    var userList: UserList!
    var currentItemVariable: UserVariable!
    var isCurrentLoopInitialized = false
    var index = 0

    public required override init() { super.init() }

    open override func delegate(_ delta: Float) -> Bool {
        if !isCurrentLoopInitialized {
            currentTime = 0
            isCurrentLoopInitialized = true
        }
        guard let userList = userList else { return true }
        let items = userList.value
        guard index < items.count else { return true }
        currentItemVariable?.setValue(items[index])
        currentTime += delta
        if let action = action, action.act(delta), !isLoopDelayNeeded() {
            index += 1
            isCurrentLoopInitialized = false
            action.restart()
        }
        return false
    }

    open override func restart() {
        isCurrentLoopInitialized = false
        index = 0
        super.restart()
    }

    public func setUserList(_ userList: UserList) { self.userList = userList }
    public func setCurrentItemVariable(_ variable: UserVariable) { self.currentItemVariable = variable }
}
