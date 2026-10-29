import Foundation

/// Аналог интерфейса Brick. UI-часть (getView, getPrototypeView, CheckBox, spinners)
/// вынесена в отдельный слой (BrickView) и будет портирована вместе с UI.
public protocol Brick: AnyObject {
    func addRequiredResources(_ resourcesSet: ResourcesSet)
    func addActionToSequence(sprite: Sprite, sequence: ScriptSequenceAction)

    func clone() -> Brick
    func addToFlatList(_ bricks: inout [Brick])
    func consistsOfMultipleParts() -> Bool
    func getAllParts() -> [Brick]

    var script: Script? { get }
    var positionInScript: Int { get }
    var parent: Brick? { get }
    func setParent(_ parent: Brick?)

    var dragAndDropTargetList: [Brick] { get }
    var positionInDragAndDropTargetList: Int { get }

    func removeChild(_ brick: Brick) -> Bool

    var isCommentedOut: Bool { get }
    func setCommentedOut(_ commentedOut: Bool)

    func hasHelpPage() -> Bool
    func getHelpUrl(category: String) -> String

    var brickID: UUID { get }

    func findBricksInNestedBricks(brickIds: [UUID]) -> [Brick]?
    func addBrickInNestedBrick(parentId: UUID, subStackIndex: Int, bricksToAdd: [Brick]) -> Bool
}
