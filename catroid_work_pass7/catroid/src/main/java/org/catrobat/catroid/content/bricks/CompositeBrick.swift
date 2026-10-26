import Foundation

/// Брики-контейнеры (if/loop/...). Списки get/set, т.к. в Swift массивы — значения.
public protocol CompositeBrick: Brick {
    var hasSecondaryList: Bool { get }
    var nestedBricks: [Brick] { get set }
    var secondaryNestedBricks: [Brick] { get set }
}
