import Foundation

open class ReadListFromDeviceAction: AsynchronousAction {
    var userList: UserList!
    var readActionFinished: Bool = false

    public required override init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        if userList == nil {
            return true
        }
        return super.act(delta)
    }

    open override func initialize() {
        readActionFinished = false
        guard let list = userList,
              let projectDirectory = ProjectManager.shared.currentProject?.directory else {
            readActionFinished = true
            return
        }
        let stored = DeviceListAccessor(projectDirectory).readDictionary()
        if let values = stored[list.name] as? [Any] { list.value = values }
        readActionFinished = true
    }

    open override func isFinished() -> Bool {
        return readActionFinished
    }

    public func setUserList(_ userList: UserList) {
        self.userList = userList
    }
}
