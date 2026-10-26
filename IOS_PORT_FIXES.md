# iOS port repair pass (2026-10-25)

This is an in-progress repair pass, not a claim that the project now builds.

## Fixed in this pass
- Replaced Java syntax in `StopAllScriptsAction.swift` with Swift syntax and the available `Look`/`Action` APIs.
- Rewrote `StopOtherScriptsAction.swift` to use Swift arrays, `filter`, and safe casts instead of Java `Array`, `Iterator`, and casts.
- Renamed the generated duplicate scene declaration in `StageListener.swift` into a compatibility bridge, since the canonical `StageScene` already exists in `StageScene.swift`.
- Connected `StageViewController` to a `StageScene` and exposed a `stageListener` compatibility accessor.
- Added a minimal actor registry and bubble lookup to `StageScene` for translated action callers.
- Fixed the reserved Swift keyword `repeat` in `BrickValues.swift` (`repeatCount`).
- Replaced unresolved Android `BuildConfig`/URL constants and Java `Calendar.MAY` usage in `Constants.swift` with iOS-compatible values.

## Known limitations
- This environment is Linux and does not include Xcode/UIKit/SpriteKit SDKs, so an iOS build cannot be run here.
- The remaining missing classes and behavior require further porting, not blanket stubs. Treat this as an intermediate source repair only.

## Follow-up pass
- Added Swift implementations of `AsynchronousAction`, `EventAction`, and `LoopAction` based on the corresponding original Kotlin classes, rather than adding empty typealiases. These establish the action lifecycle and loop timing API for translated actions.
- This is still an intermediate pass. Several other translated files retain Java syntax (for example `ForItemInUserListAction.swift`), and the full iOS target cannot be compiled in this Linux environment.

## Follow-up pass 3
- Rewrote `ForItemInUserListAction.swift` to use Swift array indexing and safe action handling.
- Rewrote `ForVariableFromToAction.swift` to remove Java-style numeric casts and use Swift numeric conversions.
- Added `UserVariable.setValue(_:)` required by translated actions.
- Not verified as a successful iOS build; remaining issues need further passes.


## Follow-up pass 4
- Added `UserVariable.isVisible` / `setVisible` compatibility accessors used by translated actions.
- Rewrote `WaitTillIdleAction.swift` using Swift array APIs and casts.
- Rewrote `ThinkSayBubbleAction.swift` to remove Java declarations and use the Swift `StageListener` bridge.
- Rewrote `HideTextAction.swift` to use Swift casts and the actual `StageScene.actors` array.
- These changes are static source repairs only; an iOS/Xcode build has not been run in this environment.

## Pass 6 — Swift syntax and source-file cleanup

This pass was checked with the Swift frontend parser across every `*.swift` file in the archive; all files passed `swiftc -frontend -parse` in the Linux environment.

- Renamed three Swift files whose filenames had an invisible U+2060 suffix (`BottomBar`, `TextActor`, `StageResourceHolder`) so they have normal `.swift` extensions.
- Fixed invalid closure syntax in `ViewSwitchLock.swift`.
- Replaced Kotlin `val` remnants and unsupported `protected` access in view controllers.
- Removed Java/Kotlin declaration syntax from `WaitForSoundAction.swift` and `ComeToFrontAction.swift`.
- Replaced a Java `new ReadTask().execute(...)` call in `ReadListFromDeviceAction.swift` with a safe completion fallback because the Android device-read task is not implemented in this iOS layer.
- Replaced Java `new` expressions in the two bubble bricks and removed a stray token in `ReportBrick.swift`.
- Fixed Java float suffixes in `CameraPositioner.swift`.
- Completed the truncated `ScreenshotSaver.swift` image-construction method using CoreGraphics.

Important: parser success only verifies Swift syntax. It does not establish that the full iOS target type-checks, links, or builds; an Xcode/iOS SDK build is still required. Some Android-only behaviors remain placeholders.


## Pass 7 — stage API integration
- Added the missing `Actor.getActions()` compatibility accessor used by translated action classes.
- Implemented `StageScene` bubble storage/lookup/removal and clone removal methods required by `StageListener` and clone/bubble actions.
- Updated `project.yml` to include `stage/` Swift sources; previously the target explicitly excluded the scene implementation while core actions referenced it. The UI draft remains excluded.
- These are source-level repairs. No Xcode/iOS SDK is available in this Linux environment, so the target still needs a real Xcode build and type-check.

## Pass 8 — sound/event compatibility
- Added Swift `SoundFilePathWithSprite` with identity-based sprite comparison.
- Added an iOS sound playback-state bridge and compatibility state on `MidiSoundManager`, so `WaitForSoundAction` no longer contains Java collection syntax or depends on Android-only player classes.
- Rewrote `WaitForSoundAction` and `WaitTillIdleAction` using Swift collection APIs.
- Added a minimal `UserDefinedReceiverBrick` runtime class for user-defined script headers.
- Removed optional singleton access in `WaitForBubbleBrickAction` by using `StageListener.shared`.
- Parsed all 386 Swift source files with `swiftc -parse`; no syntax errors. This is not an iOS SDK typecheck/build, and the sound manager bridge currently tracks playback state but does not itself play audio.
