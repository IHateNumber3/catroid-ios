import Foundation

/// UserData<T> в Java; здесь значение типизировано в реализациях (UserVariable: Any, UserList: [Any]).
public protocol UserData: Nameable {
    var deviceKey: UUID { get }
    func reset()
}
