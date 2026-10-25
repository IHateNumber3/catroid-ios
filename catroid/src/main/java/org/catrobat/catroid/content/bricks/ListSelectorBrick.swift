import Foundation

/// В Kotlin это абстрактный класс с UI; здесь — только модельная часть.
public protocol ListSelectorBrick: Brick {
    var userLists: [UserList] { get set }
    func deselectElements(_ deletedElements: [UserData])
}

public extension ListSelectorBrick {
    func deselectElements(_ deletedElements: [UserData]) {
        for element in deletedElements {
            userLists.removeAll { $0.name == element.name }
        }
    }
}
