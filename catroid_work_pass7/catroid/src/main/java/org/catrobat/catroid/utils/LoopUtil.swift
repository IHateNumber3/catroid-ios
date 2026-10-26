import Foundation

public enum LoopUtil {
    private static let loopDelayBricks: Set<String> = [
        "PlaceAtBrick", "SetXBrick", "SetYBrick", "ChangeXByNBrick", "ChangeYByNBrick", "GoToBrick",
        "IfOnEdgeBounceBrick", "MoveNStepsBrick", "TurnLeftBrick", "TurnRightBrick", "PointInDirectionBrick",
        "PointToBrick", "SetLookBrick", "SetLookByIndexBrick", "NextLookBrick", "PreviousLookBrick",
        "SetSizeToBrick", "ChangeSizeByNBrick", "SetTransparencyBrick", "ChangeTransparencyByNBrick",
        "SetBrightnessBrick", "ChangeBrightnessByNBrick", "SetColorBrick", "ChangeColorByNBrick",
        "SetBackgroundBrick", "SetBackgroundByIndexBrick", "SetVolumeToBrick", "ChangeVolumeByNBrick",
        "SetTempoBrick"
    ]

    /// Точное совпадение класса (KClass.contains), без учёта наследников — как в Kotlin.
    public static func checkLoopBrickForLoopDelay(_ loopBrick: CompositeBrick, _ script: Script) -> Bool {
        var all: [Brick] = []
        loopBrick.addToFlatList(&all)
        if let s = script as? UserDefinedScript, !s.screenRefresh { return false }
        for brick in all where !brick.isCommentedOut {
            if loopDelayBricks.contains(String(describing: type(of: brick))) { return true }
        }
        return false
    }

    public static func isAnyStitchRunning() -> Bool {
        guard let project = ProjectManager.shared.currentProject else { return false }
        return project.getSpriteListWithClones().contains { $0.runningStitch.isRunning }
    }
}
