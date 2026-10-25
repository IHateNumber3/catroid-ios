import Foundation

open class ReadListFromDeviceAction: AsynchronousAction {
    var userList: UserList!
    var readActionFinished: Bool = false

    public required init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        if userList == nil {
            return true
        }
        return super.act(delta)
    }

    public func initialize() {
        readActionFinished = false
        new ReadListFromDeviceAction.ReadTask().execute(userList)
    }

    public func isFinished() -> Bool {
        return readActionFinished
    }

    public func setUserList(_ userList: UserList) {
        self.userList = userList
    }
}
