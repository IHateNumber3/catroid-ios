# iOS port fixes


## Pass 5
- Removed duplicate `stageListener` / `currentStageScene` declarations and duplicate scene creation in `StageActivity.swift`.
- Added a separate SpriteKit-node collection to `StageScene` so native text actors can be added/removed without pretending they are custom `gdx.Actor` instances.
- Rewrote `ShowTextColorSizeAlignmentAction.swift` using Swift initializers and StageListener APIs; it replaces an existing label for the same variable/sprite and updates its value.
- Fixed `HideTextAction.swift` to search/remove SpriteKit text nodes through public accessors.
- Fixed `SetTextAction.swift` initializer and logging calls.
- Adjusted `WaitTillIdleAction.swift` to use the custom actor's `actions` property.

These are source-level repairs only. An iOS build still needs to be run in Xcode on macOS; this Linux environment cannot verify UIKit/SpriteKit compilation.
