import Foundation

open class ReadVariableFromDeviceAction: AsynchronousAction {
    var userVariable: UserVariable!
    var readActionFinished: Bool = false

    public required init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        if userVariable == nil {
            return true
        }
        return super.act(delta)
    }

    public func initialize() {
        readActionFinished = false
        ReadTask().execute(userVariable)
    }

    public func isFinished() -> Bool {
        return readActionFinished
    }

    public func setUserVariable(_ userVariable: UserVariable) {
        self.userVariable = userVariable
    }
}
