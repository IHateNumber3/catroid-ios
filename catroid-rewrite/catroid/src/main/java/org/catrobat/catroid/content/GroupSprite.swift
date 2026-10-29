import Foundation
import os

public final class GroupSprite: Sprite {

    private var collapsed = true

    public override init(name: String = "") {
        super.init(name: name)
    }

    public func getGroupItems() -> [GroupItemSprite] {
        let all = ProjectManager.shared.currentlyPlayingScene.spriteList
        var items: [GroupItemSprite] = []
        guard let position = all.firstIndex(of: self) else { return items }
        for sprite in all[(position + 1)...] {
            if let item = sprite as? GroupItemSprite {
                items.append(item)
            } else {
                break
            }
        }
        return items
    }

    public var isCollapsed: Bool { return collapsed }

    public func setCollapsed(_ collapsed: Bool) {
        self.collapsed = collapsed
        getGroupItems().forEach { $0.setCollapsed(collapsed) }
    }

    public var numberOfItems: Int { return getGroupItems().count }

    public static func getSpritesFromGroup(withGroupName groupName: String, sprites: [Sprite]) -> [Sprite] {
        var result: [Sprite] = []
        let position = sprites.firstIndex { $0.name == groupName } ?? sprites.count
        var child = position + 1
        while child < sprites.count {
            let candidate = sprites[child]
            if candidate is GroupItemSprite {
                result.append(candidate)
            } else {
                break
            }
            child += 1
        }
        return result
    }

    public override func createCollisionPolygons() {
        Logger(subsystem: "org.catrobat.catroid", category: "GroupSprite")
            .info("Creating Collision Polygons for all Sprites of group!")
        let all = ProjectManager.shared.currentlyPlayingScene.spriteList
        for sprite in Self.getSpritesFromGroup(withGroupName: name, sprites: all) {
            sprite.lookList.forEach { $0.collisionInformation.calculate() }
        }
    }
}
