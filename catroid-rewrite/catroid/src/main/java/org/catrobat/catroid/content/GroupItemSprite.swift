import Foundation

public final class GroupItemSprite: Sprite {

    private var collapsed = true

    public override init(name: String = "") {
        super.init(name: name)
    }

    public var isCollapsed: Bool { return collapsed }

    public func setCollapsed(_ collapsed: Bool) {
        self.collapsed = collapsed
    }
}
