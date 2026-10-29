import Foundation

/// Брик-заголовок скрипта. Script хранит брик сильно, брик скрипт — слабо (нет цикла).
/// Исключение: брик, создавший скрипт сам (`init()`), держит его до тех пор, пока скрипт
/// не будет добавлен в Sprite (см. Script.releaseBrickKeepAlive).
open class ScriptBrickBaseType: BrickBaseType, ScriptBrick {

    public private(set) weak var ownerScript: Script?
    var scriptKeepAlive: Script?

    public required init() { super.init() }

    public init(script: Script, ownsScript: Bool = false) {
        super.init()
        ownerScript = script
        if ownsScript { scriptKeepAlive = script }
        script.setScriptBrick(self)
        commentedOut = script.commentedOut
    }

    open override func copyState(from other: BrickBaseType) {
        super.copyState(from: other)
        if let o = other as? ScriptBrickBaseType, let s = o.ownerScript {
            let copy = s.clone()
            copy.setScriptBrick(self)
            ownerScript = copy
            scriptKeepAlive = copy
        }
    }

    open override var script: Script? { return ownerScript }

    open override func addToFlatList(_ bricks: inout [Brick]) {
        super.addToFlatList(&bricks)
        for brick in script?.brickList ?? [] { brick.addToFlatList(&bricks) }
    }

    open override var positionInScript: Int { return -1 }
    open override var dragAndDropTargetList: [Brick] { return script?.brickList ?? [] }
    open override var positionInDragAndDropTargetList: Int { return -1 }

    open override func setCommentedOut(_ commentedOut: Bool) {
        super.setCommentedOut(commentedOut)
        script?.setCommentedOut(commentedOut)
    }
}
