import Foundation

// Swift counterparts for model types that were originally Java/Kotlin-only.
public struct ParameterizedData {
    public var currentPosition: Int = 0
    public var listSize: Int = 1
    public var failMessages = ""
    public var successMessages = ""
    public var currentParameters = ""
    public init(currentPosition: Int = 0, listSize: Int = 1, failMessages: String = "", successMessages: String = "", currentParameters: String = "") {
        self.currentPosition = currentPosition; self.listSize = listSize
        self.failMessages = failMessages; self.successMessages = successMessages; self.currentParameters = currentParameters
    }
    public mutating func reset() { currentPosition = 0; listSize = 1; failMessages = ""; successMessages = ""; currentParameters = "" }
}

public final class SetNextLookAction {
    public init() {}
}

public enum PickableDrum: Int, CaseIterable {
    case SNARE_DRUM = 38, BASS_DRUM = 35, SIDE_STICK = 37, CRASH_CYMBAL = 49, OPEN_HI_HAT = 46, CLOSED_HI_HAT = 42, TAMBOURINE = 54, HAND_CLAP = 39, CLAVES = 75, WOOD_BLOCK = 76, COWBELL = 56, TRIANGLE = 81, BONGO = 60, CONGA = 63, CABASA = 69, GUIRO = 73, VIBRASLAP = 58, OPEN_CUICA = 79
    public var value: Int { rawValue }
}

public enum LegoNxtMotorMoveBrick { public enum Motor { case MOTOR_A, MOTOR_B, MOTOR_C, MOTOR_B_C } }
public enum LegoNxtMotorStopBrick { public enum Motor { case MOTOR_A, MOTOR_B, MOTOR_C, MOTOR_B_C, ALL_MOTORS } }
public enum LegoNxtMotorTurnAngleBrick { public enum Motor { case MOTOR_A, MOTOR_B, MOTOR_C, MOTOR_B_C } }
public enum LegoEv3MotorMoveBrick { public enum Motor { case MOTOR_A, MOTOR_B, MOTOR_C, MOTOR_D, MOTOR_B_C } }
public enum LegoEv3MotorStopBrick { public enum Motor { case MOTOR_A, MOTOR_B, MOTOR_C, MOTOR_D, MOTOR_B_C, ALL_MOTORS } }
public enum LegoEv3SetLedBrick { public enum LedStatus { case LED_OFF, LED_GREEN, LED_RED, LED_ORANGE, LED_GREEN_FLASHING, LED_RED_FLASHING, LED_ORANGE_FLASHING, LED_GREEN_PULSE, LED_RED_PULSE, LED_ORANGE_PULSE } }
public enum PhiroPlayToneBrick { public enum Tone { case DO, RE, MI, FA, SO, LA, TI } }
public enum PhiroMotorMoveForwardBrick { public enum Motor { case MOTOR_LEFT, MOTOR_RIGHT, MOTOR_BOTH } }
public enum PhiroMotorMoveBackwardBrick { public enum Motor { case MOTOR_LEFT, MOTOR_RIGHT, MOTOR_BOTH } }
public enum PhiroRGBLightBrick { public enum Eye { case LEFT, RIGHT, BOTH } }
public enum PhiroMotorStopBrick { public enum Motor { case MOTOR_LEFT, MOTOR_RIGHT, MOTOR_BOTH } }
public enum ArcBrick { public enum Directions { case LEFT, RIGHT } }

// Model-only brick placeholder: UI and sound selection are implemented separately.
open class PlaySoundBrick: BrickBaseType {
    public var sound: SoundInfo?
    public func getSound() -> SoundInfo? { sound }
    public func setSound(_ sound: SoundInfo?) { self.sound = sound }
}

public final class DefaultProjectHandler {
    public enum ProjectCreatorType { case PROJECT_CREATOR_DEFAULT, PROJECT_CREATOR_CAST }
    public static let shared = DefaultProjectHandler()
    private var creatorType: ProjectCreatorType = .PROJECT_CREATOR_DEFAULT
    private init() {}
    public func setDefaultProjectCreator(_ type: ProjectCreatorType) { creatorType = type }
    public static func createAndSaveEmptyProject(name: String, landscapeMode: Bool, castEnabled: Bool) throws -> Project {
        return Project(name: name, landscapeMode: landscapeMode, isCastProject: castEnabled)
    }
    public static func createAndSaveDefaultProject() throws -> Project {
        return Project(name: "Untitled")
    }
    public static func createAndSaveDefaultProject(name: String, landscapeMode: Bool) throws -> Project {
        return Project(name: name, landscapeMode: landscapeMode)
    }
}
