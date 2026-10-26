import Foundation

open class ClearUserListAction: TemporalAction {
    var userList: UserList!

    public override init() { super.init() }

    open override func update(_ percent: Float) {
        if userList == nil {
            return
        }
        userList.reset()
    }

    public func setUserList(_ userVariable: UserList) {
        self.userList = userVariable
    }
}
