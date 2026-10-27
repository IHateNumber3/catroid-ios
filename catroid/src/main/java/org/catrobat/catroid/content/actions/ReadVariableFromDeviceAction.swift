import Foundation

open class ReadVariableFromDeviceAction: AsynchronousAction {
    var userVariable: UserVariable!
    var readActionFinished: Bool = false

    public required override init() { super.init() }

    open override func act(_ delta: Float) -> Bool {
        if userVariable == nil {
            return true
        }
        return super.act(delta)
    }

    open override func initialize() {
        readActionFinished = false
        ReadTask().execute(userVariable)
    }

    open override func isFinished() -> Bool {
        return readActionFinished
    }

    public func setUserVariable(_ userVariable: UserVariable) {
        self.userVariable = userVariable
    }
}
