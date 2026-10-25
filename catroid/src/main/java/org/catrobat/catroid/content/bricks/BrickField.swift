import Foundation

/// Ключи формул. rawValue = имя константы в Java (нужно для совместимости XML).
/// FormulaField в Java — интерфейс-маркер; в Swift это AnyHashable.
public typealias FormulaField = AnyHashable

public enum BrickField: String {
    case color = "COLOR"
    case colorChange = "COLOR_CHANGE"
    case brightness = "BRIGHTNESS"
    case brightnessChange = "BRIGHTNESS_CHANGE"
    case xPosition = "X_POSITION"
    case yPosition = "Y_POSITION"
    case xPositionChange = "X_POSITION_CHANGE"
    case yPositionChange = "Y_POSITION_CHANGE"
    case transparency = "TRANSPARENCY"
    case transparencyChange = "TRANSPARENCY_CHANGE"
    case size = "SIZE"
    case sizeChange = "SIZE_CHANGE"
    case volume = "VOLUME"
    case volumeChange = "VOLUME_CHANGE"
    case xDestination = "X_DESTINATION"
    case yDestination = "Y_DESTINATION"
    case steps = "STEPS"
    case durationInSeconds = "DURATION_IN_SECONDS"
    case degrees = "DEGREES"
    case turnRightDegrees = "TURN_RIGHT_DEGREES"
    case turnLeftDegrees = "TURN_LEFT_DEGREES"
    case timeToWaitInSeconds = "TIME_TO_WAIT_IN_SECONDS"
    case variable = "VARIABLE"
    case variableChange = "VARIABLE_CHANGE"
    case webRequest = "WEB_REQUEST"
    case lookRequest = "LOOK_REQUEST"
    case lookNew = "LOOK_NEW"
    case lookCopy = "LOOK_COPY"
    case backgroundRequest = "BACKGROUND_REQUEST"
    case writeFilename = "WRITE_FILENAME"
    case readFilename = "READ_FILENAME"
    case tempo = "TEMPO"
    case horizontalFlexibility = "HORIZONTAL_FLEXIBILITY"
    case verticalFlexibility = "VERTICAL_FLEXIBILITY"
    case tempoChange = "TEMPO_CHANGE"
    case beatsToPause = "BEATS_TO_PAUSE"
    case noteToPlay = "NOTE_TO_PLAY"
    case beatsToPlayNote = "BEATS_TO_PLAY_NOTE"
    case openUrl = "OPEN_URL"
    case playDrum = "PLAY_DRUM"
    case playSoundAt = "PLAY_SOUND_AT"
    case penSize = "PEN_SIZE"
    case penColorRed = "PEN_COLOR_RED"
    case penColorGreen = "PEN_COLOR_GREEN"
    case penColorBlue = "PEN_COLOR_BLUE"
    case ifCondition = "IF_CONDITION"
    case timesToRepeat = "TIMES_TO_REPEAT"
    case forLoopFrom = "FOR_LOOP_FROM"
    case forLoopTo = "FOR_LOOP_TO"
    case vibrateDurationInSeconds = "VIBRATE_DURATION_IN_SECONDS"
    case userBrick = "USER_BRICK"
    case note = "NOTE"
    case speak = "SPEAK"
    case showtext = "SHOWTEXT"
    case string = "STRING"
    case rotationStyle = "ROTATION_STYLE"
    case repeatUntilCondition = "REPEAT_UNTIL_CONDITION"
    case askQuestion = "ASK_QUESTION"
    case nfcNdefMessage = "NFC_NDEF_MESSAGE"
    case askSpeechQuestion = "ASK_SPEECH_QUESTION"
    case lookIndex = "LOOK_INDEX"
    case backgroundIndex = "BACKGROUND_INDEX"
    case backgroundWaitIndex = "BACKGROUND_WAIT_INDEX"
    case reportBrick = "REPORT_BRICK"
    case legoNxtSpeed = "LEGO_NXT_SPEED"
    case legoNxtDegrees = "LEGO_NXT_DEGREES"
    case legoNxtFrequency = "LEGO_NXT_FREQUENCY"
    case legoNxtDurationInSeconds = "LEGO_NXT_DURATION_IN_SECONDS"
    case legoEv3Frequency = "LEGO_EV3_FREQUENCY"
    case legoEv3DurationInSeconds = "LEGO_EV3_DURATION_IN_SECONDS"
    case legoEv3Volume = "LEGO_EV3_VOLUME"
    case legoEv3Speed = "LEGO_EV3_SPEED"
    case legoEv3Power = "LEGO_EV3_POWER"
    case legoEv3PeriodInSeconds = "LEGO_EV3_PERIOD_IN_SECONDS"
    case legoEv3Degrees = "LEGO_EV3_DEGREES"
    case droneTimeToFlyInSeconds = "DRONE_TIME_TO_FLY_IN_SECONDS"
    case listAddItem = "LIST_ADD_ITEM"
    case listDeleteItem = "LIST_DELETE_ITEM"
    case insertItemIntoUserlistValue = "INSERT_ITEM_INTO_USERLIST_VALUE"
    case insertItemIntoUserlistIndex = "INSERT_ITEM_INTO_USERLIST_INDEX"
    case replaceItemInUserlistValue = "REPLACE_ITEM_IN_USERLIST_VALUE"
    case replaceItemInUserlistIndex = "REPLACE_ITEM_IN_USERLIST_INDEX"
    case dronePowerInPercent = "DRONE_POWER_IN_PERCENT"
    case droneAltitudeLimit = "DRONE_ALTITUDE_LIMIT"
    case droneVerticalSpeedMax = "DRONE_VERTICAL_SPEED_MAX"
    case droneRotationMax = "DRONE_ROTATION_MAX"
    case droneTiltAngle = "DRONE_TILT_ANGLE"
    case jumpingSumoSpeed = "JUMPING_SUMO_SPEED"
    case jumpingSumoTimeToDriveInSeconds = "JUMPING_SUMO_TIME_TO_DRIVE_IN_SECONDS"
    case jumpingSumoVolume = "JUMPING_SUMO_VOLUME"
    case jumpingSumoRotate = "JUMPING_SUMO_ROTATE"
    case phiroSpeed = "PHIRO_SPEED"
    case phiroDurationInSeconds = "PHIRO_DURATION_IN_SECONDS"
    case phiroLightRed = "PHIRO_LIGHT_RED"
    case phiroLightGreen = "PHIRO_LIGHT_GREEN"
    case phiroLightBlue = "PHIRO_LIGHT_BLUE"
    case physicsBounceFactor = "PHYSICS_BOUNCE_FACTOR"
    case physicsFriction = "PHYSICS_FRICTION"
    case physicsGravityX = "PHYSICS_GRAVITY_X"
    case physicsGravityY = "PHYSICS_GRAVITY_Y"
    case physicsMass = "PHYSICS_MASS"
    case physicsVelocityX = "PHYSICS_VELOCITY_X"
    case physicsVelocityY = "PHYSICS_VELOCITY_Y"
    case physicsTurnLeftSpeed = "PHYSICS_TURN_LEFT_SPEED"
    case physicsTurnRightSpeed = "PHYSICS_TURN_RIGHT_SPEED"
    case arduinoAnalogPinValue = "ARDUINO_ANALOG_PIN_VALUE"
    case arduinoAnalogPinNumber = "ARDUINO_ANALOG_PIN_NUMBER"
    case arduinoDigitalPinValue = "ARDUINO_DIGITAL_PIN_VALUE"
    case arduinoDigitalPinNumber = "ARDUINO_DIGITAL_PIN_NUMBER"
    case raspiDigitalPinValue = "RASPI_DIGITAL_PIN_VALUE"
    case raspiDigitalPinNumber = "RASPI_DIGITAL_PIN_NUMBER"
    case raspiPwmPercentage = "RASPI_PWM_PERCENTAGE"
    case raspiPwmFrequency = "RASPI_PWM_FREQUENCY"
    case embroideryLength = "EMBROIDERY_LENGTH"
    case zigzagEmbroideryLength = "ZIGZAG_EMBROIDERY_LENGTH"
    case zigzagEmbroideryWidth = "ZIGZAG_EMBROIDERY_WIDTH"
    case threadColor = "THREAD_COLOR"
    case storeCsvIntoUserlistColumn = "STORE_CSV_INTO_USERLIST_COLUMN"
    case storeCsvIntoUserlistCsv = "STORE_CSV_INTO_USERLIST_CSV"
    case assertEqualsExpected = "ASSERT_EQUALS_EXPECTED"
    case assertEqualsActual = "ASSERT_EQUALS_ACTUAL"
    case assertLoopActual = "ASSERT_LOOP_ACTUAL"

    private static let expectsStringValue: Set<BrickField> = [
        .variable,
        .note,
        .speak,
        .string,
        .askQuestion,
        .nfcNdefMessage,
        .askSpeechQuestion,
        .listAddItem,
        .insertItemIntoUserlistValue,
        .replaceItemInUserlistValue
    ]

    public static func isExpectingStringValue(_ field: BrickField) -> Bool {
        return expectsStringValue.contains(field)
    }
}

public enum BrickData: String {
    case assertListsExpected = "ASSERT_LISTS_EXPECTED"
    case assertListsActual = "ASSERT_LISTS_ACTUAL"
    case forItemInUserlistList = "FOR_ITEM_IN_USERLIST_LIST"
    case forItemInUserlistVariable = "FOR_ITEM_IN_USERLIST_VARIABLE"

    public static let expectsUserList: [BrickData] = [.assertListsExpected, .assertListsActual, .forItemInUserlistList]

    public static func isUserList(_ field: BrickData) -> Bool {
        return expectsUserList.contains(field)
    }
}

/// Ресурсы, которые требует бриксет (Brick.TEXT_TO_SPEECH и т.д.)
public enum BrickResource: Int {
    case textToSpeech = 1
    case bluetoothLegoNxt = 2
    case physics = 3
    case faceDetection = 4
    case textDetection = 5
    case bluetoothSensorsArduino = 6
    case socketRaspi = 7
    case cameraFlash = 8
    case vibration = 9
    case bluetoothPhiro = 10
    case cameraBack = 11
    case cameraFront = 12
    case sensorAcceleration = 13
    case sensorInclination = 14
    case sensorCompass = 15
    case nfcAdapter = 16
    case video = 17
    case sensorGps = 18
    case collision = 19
    case bluetoothLegoEv3 = 20
    case networkConnection = 21
    case castRequired = 22
    case speechRecognition = 23
    case microphone = 24
    case storageRead = 25
    case storageWrite = 26
    case poseDetection = 27
    case objectDetection = 28
    case bluetoothMultiplayer = 29
}

public final class ResourcesSet {
    public private(set) var resources: Set<BrickResource> = []
    public init() {}
    @discardableResult
    public func add(_ r: BrickResource) -> Bool { return resources.insert(r).inserted }
    public func contains(_ r: BrickResource) -> Bool { return resources.contains(r) }
    @discardableResult
    public func remove(_ r: BrickResource) -> Bool { return resources.remove(r) != nil }
    public var isEmpty: Bool { return resources.isEmpty }
}
