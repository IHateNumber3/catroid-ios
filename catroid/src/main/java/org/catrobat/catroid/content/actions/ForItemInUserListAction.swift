import Foundation

open class ForItemInUserListAction: LoopAction {
    var userList: UserList!
    var currentItemVariable: UserVariable!
    var isCurrentLoopInitialized: Bool = false
    var index: Int = 0

    public required init() { super.init() }

    open override func delegate(_ delta: Float) -> Bool {
        if !isCurrentLoopInitialized {
            setCurrentTime(0)
            isCurrentLoopInitialized = true
        }
        if userList == nil {
            return true
        }
        List<Object> list = userList.value
        if list == nil || index >= list.size() {
            return true
        }
        setCurrentItemVariable(list.get(index))
        setCurrentTime(getCurrentTime() + delta)
        if action != nil && action.act(delta) && !isLoopDelayNeeded() {
            index++
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

    public func setUserList(_ userList: UserList) {
        self.userList = userList
    }

    public func setCurrentItemVariable(_ variable: UserVariable) {
        self.currentItemVariable = variable
    }

    private func setCurrentItemVariable(_ listItem: Any) {
        self.currentItemVariable.setValue(listItem)
    }
}
