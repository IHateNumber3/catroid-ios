import Foundation

public struct Scope {
    public let project: Project?
    public let sprite: Sprite
    public let sequence: SequenceAction?

    public init(project: Project?, sprite: Sprite, sequence: SequenceAction?) {
        self.project = project
        self.sprite = sprite
        self.sequence = sequence
    }
}
