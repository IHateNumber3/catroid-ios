import Foundation
import AVFoundation
import UIKit
import Speech

/// Compatibility adapters for actions whose Android implementations are Kotlin-only.
/// Factory arguments are retained in configuration so the iOS implementations can consume them.
open class IOSMissingActionAdapter: Action {
    public var configuration: [String: Any] = [:]
    public required override init() { super.init() }
    public func store<T>(_ key: String, _ value: T) { configuration[key] = value }
    /// Default is a safe one-shot completion for actions whose platform service is not yet available.
    /// Core look/sound/variable actions are implemented below instead of relying on this fallback.
    open override func act(_ delta: Float) -> Bool { return true }
}

open class IOSMissingEventActionAdapter: EventAction {
    public var configuration: [String: Any] = [:]
    public func store<T>(_ key: String, _ value: T) { configuration[key] = value }
    public func setWait(_ wait: Bool) { self.wait = wait; configuration["wait"] = wait }
}

open class IOSMissingLoopActionAdapter: LoopAction {
    public var configuration: [String: Any] = [:]
    public func store<T>(_ key: String, _ value: T) { configuration[key] = value }
}

public extension IOSMissingActionAdapter {
    func setAccessor<T>(_ value: T) { store("setAccessor", value) }
    func setActive<T>(_ value: T) { store("setActive", value) }
    func setActualFormula<T>(_ value: T) { store("setActualFormula", value) }
    func setActualUserList<T>(_ value: T) { store("setActualUserList", value) }
    func setAndroidStringProvider<T>(_ value: T) { store("setAndroidStringProvider", value) }
    func setAnswerVariable<T>(_ value: T) { store("setAnswerVariable", value) }
    func setBackgroundSprite<T>(_ value: T) { store("setBackgroundSprite", value) }
    func setBeats<T>(_ value: T) { store("setBeats", value) }
    func setBrightness<T>(_ value: T) { store("setBrightness", value) }
    func setBroadcastMessage<T>(_ value: T) { store("setBroadcastMessage", value) }
    func setChangeVariable<T>(_ value: T) { store("setChangeVariable", value) }
    func setColor<T>(_ value: T) { store("setColor", value) }
    func setDegrees<T>(_ value: T) { store("setDegrees", value) }
    func setDeleteFile<T>(_ value: T) { store("setDeleteFile", value) }
    func setDestinationSprite<T>(_ value: T) { store("setDestinationSprite", value) }
    func setDirection<T>(_ value: T) { store("setDirection", value) }
    func setDuration<T>(_ value: T) { store("setDuration", value) }
    func setElseAction<T>(_ value: T) { store("setElseAction", value) }
    func setExpectedFormula<T>(_ value: T) { store("setExpectedFormula", value) }
    func setExpectedList<T>(_ value: T) { store("setExpectedList", value) }
    func setExpectedUserList<T>(_ value: T) { store("setExpectedUserList", value) }
    func setFadeIn<T>(_ value: T) { store("setFadeIn", value) }
    func setFlashOn<T>(_ value: T) { store("setFlashOn", value) }
    func setFormula<T>(_ value: T) { store("setFormula", value) }
    func setFormulaCSVData<T>(_ value: T) { store("setFormulaCSVData", value) }
    func setFormulaColumnToExtract<T>(_ value: T) { store("setFormulaColumnToExtract", value) }
    func setFormulaIndexToDelete<T>(_ value: T) { store("setFormulaIndexToDelete", value) }
    func setFormulaIndexToInsert<T>(_ value: T) { store("setFormulaIndexToInsert", value) }
    func setFormulaIndexToReplace<T>(_ value: T) { store("setFormulaIndexToReplace", value) }
    func setFormulaItemToAdd<T>(_ value: T) { store("setFormulaItemToAdd", value) }
    func setFormulaItemToInsert<T>(_ value: T) { store("setFormulaItemToInsert", value) }
    func setFrontCamera<T>(_ value: T) { store("setFrontCamera", value) }
    func setHorizontal<T>(_ value: T) { store("setHorizontal", value) }
    func setIfAction<T>(_ value: T) { store("setIfAction", value) }
    func setIfCondition<T>(_ value: T) { store("setIfCondition", value) }
    func setInputs<T>(_ value: T) { store("setInputs", value) }
    func setInterpolation<T>(_ value: T) { store("setInterpolation", value) }
    func setListeningLanguageTag<T>(_ value: T) { store("setListeningLanguageTag", value) }
    func setLookData<T>(_ value: T) { store("setLookData", value) }
    func setLoopDelay<T>(_ value: T) { store("setLoopDelay", value) }
    func setMotorEnum<T>(_ value: T) { store("setMotorEnum", value) }
    func setOffset<T>(_ value: T) { store("setOffset", value) }
    func setParameterizedData<T>(_ value: T) { store("setParameterizedData", value) }
    func setParameters<T>(_ value: T) { store("setParameters", value) }
    func setPosition<T>(_ value: T) { store("setPosition", value) }
    func setQuestionFormula<T>(_ value: T) { store("setQuestionFormula", value) }
    func setRadius<T>(_ value: T) { store("setRadius", value) }
    func setRepeatCondition<T>(_ value: T) { store("setRepeatCondition", value) }
    func setRepeatCount<T>(_ value: T) { store("setRepeatCount", value) }
    func setScene<T>(_ value: T) { store("setScene", value) }
    func setScope<T>(_ value: T) { store("setScope", value) }
    func setSilent<T>(_ value: T) { store("setSilent", value) }
    func setSound<T>(_ value: T) { store("setSound", value) }
    func setSprite<T>(_ value: T) { store("setSprite", value) }
    func setStartX<T>(_ value: T) { store("setStartX", value) }
    func setStartY<T>(_ value: T) { store("setStartY", value) }
    func setTargetCoordinates<T>(_ value: T) { store("setTargetCoordinates", value) }
    func setTempo<T>(_ value: T) { store("setTempo", value) }
    func setUserData<T>(_ value: T) { store("setUserData", value) }
    func setUserDefinedBrickID<T>(_ value: T) { store("setUserDefinedBrickID", value) }
    func setUserList<T>(_ value: T) { store("setUserList", value) }
    func setUserVariable<T>(_ value: T) { store("setUserVariable", value) }
    func setVertical<T>(_ value: T) { store("setVertical", value) }
    func setWait<T>(_ value: T) { store("setWait", value) }
}

public extension IOSMissingEventActionAdapter {
    func setAccessor<T>(_ value: T) { store("setAccessor", value) }
    func setActive<T>(_ value: T) { store("setActive", value) }
    func setActualFormula<T>(_ value: T) { store("setActualFormula", value) }
    func setActualUserList<T>(_ value: T) { store("setActualUserList", value) }
    func setAndroidStringProvider<T>(_ value: T) { store("setAndroidStringProvider", value) }
    func setAnswerVariable<T>(_ value: T) { store("setAnswerVariable", value) }
    func setBackgroundSprite<T>(_ value: T) { store("setBackgroundSprite", value) }
    func setBeats<T>(_ value: T) { store("setBeats", value) }
    func setBrightness<T>(_ value: T) { store("setBrightness", value) }
    func setBroadcastMessage<T>(_ value: T) { store("setBroadcastMessage", value) }
    func setChangeVariable<T>(_ value: T) { store("setChangeVariable", value) }
    func setColor<T>(_ value: T) { store("setColor", value) }
    func setDegrees<T>(_ value: T) { store("setDegrees", value) }
    func setDeleteFile<T>(_ value: T) { store("setDeleteFile", value) }
    func setDestinationSprite<T>(_ value: T) { store("setDestinationSprite", value) }
    func setDirection<T>(_ value: T) { store("setDirection", value) }
    func setDuration<T>(_ value: T) { store("setDuration", value) }
    func setElseAction<T>(_ value: T) { store("setElseAction", value) }
    func setExpectedFormula<T>(_ value: T) { store("setExpectedFormula", value) }
    func setExpectedList<T>(_ value: T) { store("setExpectedList", value) }
    func setExpectedUserList<T>(_ value: T) { store("setExpectedUserList", value) }
    func setFadeIn<T>(_ value: T) { store("setFadeIn", value) }
    func setFlashOn<T>(_ value: T) { store("setFlashOn", value) }
    func setFormula<T>(_ value: T) { store("setFormula", value) }
    func setFormulaCSVData<T>(_ value: T) { store("setFormulaCSVData", value) }
    func setFormulaColumnToExtract<T>(_ value: T) { store("setFormulaColumnToExtract", value) }
    func setFormulaIndexToDelete<T>(_ value: T) { store("setFormulaIndexToDelete", value) }
    func setFormulaIndexToInsert<T>(_ value: T) { store("setFormulaIndexToInsert", value) }
    func setFormulaIndexToReplace<T>(_ value: T) { store("setFormulaIndexToReplace", value) }
    func setFormulaItemToAdd<T>(_ value: T) { store("setFormulaItemToAdd", value) }
    func setFormulaItemToInsert<T>(_ value: T) { store("setFormulaItemToInsert", value) }
    func setFrontCamera<T>(_ value: T) { store("setFrontCamera", value) }
    func setHorizontal<T>(_ value: T) { store("setHorizontal", value) }
    func setIfAction<T>(_ value: T) { store("setIfAction", value) }
    func setIfCondition<T>(_ value: T) { store("setIfCondition", value) }
    func setInputs<T>(_ value: T) { store("setInputs", value) }
    func setInterpolation<T>(_ value: T) { store("setInterpolation", value) }
    func setListeningLanguageTag<T>(_ value: T) { store("setListeningLanguageTag", value) }
    func setLookData<T>(_ value: T) { store("setLookData", value) }
    func setLoopDelay<T>(_ value: T) { store("setLoopDelay", value) }
    func setMotorEnum<T>(_ value: T) { store("setMotorEnum", value) }
    func setOffset<T>(_ value: T) { store("setOffset", value) }
    func setParameterizedData<T>(_ value: T) { store("setParameterizedData", value) }
    func setParameters<T>(_ value: T) { store("setParameters", value) }
    func setPosition<T>(_ value: T) { store("setPosition", value) }
    func setQuestionFormula<T>(_ value: T) { store("setQuestionFormula", value) }
    func setRadius<T>(_ value: T) { store("setRadius", value) }
    func setRepeatCondition<T>(_ value: T) { store("setRepeatCondition", value) }
    func setRepeatCount<T>(_ value: T) { store("setRepeatCount", value) }
    func setScene<T>(_ value: T) { store("setScene", value) }
    func setScope<T>(_ value: T) { store("setScope", value) }
    func setSilent<T>(_ value: T) { store("setSilent", value) }
    func setSound<T>(_ value: T) { store("setSound", value) }
    func setSprite<T>(_ value: T) { store("setSprite", value) }
    func setStartX<T>(_ value: T) { store("setStartX", value) }
    func setStartY<T>(_ value: T) { store("setStartY", value) }
    func setTargetCoordinates<T>(_ value: T) { store("setTargetCoordinates", value) }
    func setTempo<T>(_ value: T) { store("setTempo", value) }
    func setUserData<T>(_ value: T) { store("setUserData", value) }
    func setUserDefinedBrickID<T>(_ value: T) { store("setUserDefinedBrickID", value) }
    func setUserList<T>(_ value: T) { store("setUserList", value) }
    func setUserVariable<T>(_ value: T) { store("setUserVariable", value) }
    func setVertical<T>(_ value: T) { store("setVertical", value) }
}

public extension IOSMissingLoopActionAdapter {
    func setAccessor<T>(_ value: T) { store("setAccessor", value) }
    func setActive<T>(_ value: T) { store("setActive", value) }
    func setActualFormula<T>(_ value: T) { store("setActualFormula", value) }
    func setActualUserList<T>(_ value: T) { store("setActualUserList", value) }
    func setAndroidStringProvider<T>(_ value: T) { store("setAndroidStringProvider", value) }
    func setAnswerVariable<T>(_ value: T) { store("setAnswerVariable", value) }
    func setBackgroundSprite<T>(_ value: T) { store("setBackgroundSprite", value) }
    func setBeats<T>(_ value: T) { store("setBeats", value) }
    func setBrightness<T>(_ value: T) { store("setBrightness", value) }
    func setBroadcastMessage<T>(_ value: T) { store("setBroadcastMessage", value) }
    func setChangeVariable<T>(_ value: T) { store("setChangeVariable", value) }
    func setColor<T>(_ value: T) { store("setColor", value) }
    func setDegrees<T>(_ value: T) { store("setDegrees", value) }
    func setDeleteFile<T>(_ value: T) { store("setDeleteFile", value) }
    func setDestinationSprite<T>(_ value: T) { store("setDestinationSprite", value) }
    func setDirection<T>(_ value: T) { store("setDirection", value) }
    func setDuration<T>(_ value: T) { store("setDuration", value) }
    func setElseAction<T>(_ value: T) { store("setElseAction", value) }
    func setExpectedFormula<T>(_ value: T) { store("setExpectedFormula", value) }
    func setExpectedList<T>(_ value: T) { store("setExpectedList", value) }
    func setExpectedUserList<T>(_ value: T) { store("setExpectedUserList", value) }
    func setFadeIn<T>(_ value: T) { store("setFadeIn", value) }
    func setFlashOn<T>(_ value: T) { store("setFlashOn", value) }
    func setFormula<T>(_ value: T) { store("setFormula", value) }
    func setFormulaCSVData<T>(_ value: T) { store("setFormulaCSVData", value) }
    func setFormulaColumnToExtract<T>(_ value: T) { store("setFormulaColumnToExtract", value) }
    func setFormulaIndexToDelete<T>(_ value: T) { store("setFormulaIndexToDelete", value) }
    func setFormulaIndexToInsert<T>(_ value: T) { store("setFormulaIndexToInsert", value) }
    func setFormulaIndexToReplace<T>(_ value: T) { store("setFormulaIndexToReplace", value) }
    func setFormulaItemToAdd<T>(_ value: T) { store("setFormulaItemToAdd", value) }
    func setFormulaItemToInsert<T>(_ value: T) { store("setFormulaItemToInsert", value) }
    func setFrontCamera<T>(_ value: T) { store("setFrontCamera", value) }
    func setHorizontal<T>(_ value: T) { store("setHorizontal", value) }
    func setIfAction<T>(_ value: T) { store("setIfAction", value) }
    func setIfCondition<T>(_ value: T) { store("setIfCondition", value) }
    func setInputs<T>(_ value: T) { store("setInputs", value) }
    func setInterpolation<T>(_ value: T) { store("setInterpolation", value) }
    func setListeningLanguageTag<T>(_ value: T) { store("setListeningLanguageTag", value) }
    func setLookData<T>(_ value: T) { store("setLookData", value) }
    func setMotorEnum<T>(_ value: T) { store("setMotorEnum", value) }
    func setOffset<T>(_ value: T) { store("setOffset", value) }
    func setParameterizedData<T>(_ value: T) { store("setParameterizedData", value) }
    func setParameters<T>(_ value: T) { store("setParameters", value) }
    func setPosition<T>(_ value: T) { store("setPosition", value) }
    func setQuestionFormula<T>(_ value: T) { store("setQuestionFormula", value) }
    func setRadius<T>(_ value: T) { store("setRadius", value) }
    func setRepeatCondition<T>(_ value: T) { store("setRepeatCondition", value) }
    func setRepeatCount<T>(_ value: T) { store("setRepeatCount", value) }
    func setScene<T>(_ value: T) { store("setScene", value) }
    func setScope<T>(_ value: T) { store("setScope", value) }
    func setSilent<T>(_ value: T) { store("setSilent", value) }
    func setSound<T>(_ value: T) { store("setSound", value) }
    func setSprite<T>(_ value: T) { store("setSprite", value) }
    func setStartX<T>(_ value: T) { store("setStartX", value) }
    func setStartY<T>(_ value: T) { store("setStartY", value) }
    func setTargetCoordinates<T>(_ value: T) { store("setTargetCoordinates", value) }
    func setTempo<T>(_ value: T) { store("setTempo", value) }
    func setUserData<T>(_ value: T) { store("setUserData", value) }
    func setUserDefinedBrickID<T>(_ value: T) { store("setUserDefinedBrickID", value) }
    func setUserList<T>(_ value: T) { store("setUserList", value) }
    func setUserVariable<T>(_ value: T) { store("setUserVariable", value) }
    func setVertical<T>(_ value: T) { store("setVertical", value) }
    func setWait<T>(_ value: T) { store("setWait", value) }
}

public final class UserDefinedBrickAction: IOSMissingEventActionAdapter {
    public required override init() { super.init() }

    public override var receivingSprites: [Sprite] {
        guard let sprite = configuration["setSprite"] as? Sprite else { return [] }
        return [sprite]
    }

    public override func getEventId() -> EventId? {
        guard let id = configuration["setUserDefinedBrickID"] as? UUID else { return nil }
        let scope = configuration["setScope"] as? Scope
        let inputs = configuration["setInputs"] as? [UserDefinedBrickInput] ?? []
        let values: [Any] = inputs.map { input in
            guard let scope = scope else { return NSNull() }
            return input.value.interpretObject(scope)
        }
        return UserDefinedBrickEventId(userDefinedBrickID: id, userBrickParameters: values)
    }
}

public final class BroadcastAction: IOSMissingEventActionAdapter {
public required override init() { super.init() }
    public override var receivingSprites: [Sprite] {
        ProjectManager.shared.currentlyPlayingScene?.spriteList ?? []
    }
    public override func getEventId() -> EventId? {
        guard let message = configuration["setBroadcastMessage"] as? String else { return nil }
        return BroadcastEventId(message: message)
    }
}

public final class PlaySoundAtAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var played = false
    public override func act(_ delta: Float) -> Bool {
        guard !played else { return true }; played = true
        guard let sprite = configuration["setSprite"] as? Sprite,
              let sound = configuration["setSound"] as? SoundInfo,
              let scope = configuration["setScope"] as? Scope,
              let offsetFormula = configuration["setOffset"] as? Formula,
              let seconds = try? offsetFormula.interpretFloat(scope),
              sprite.soundList.contains(where: { $0 === sound }) else { return true }
        let milliseconds = max(0, Int(seconds * 1000))
        if sound.isMidiFile { MidiSoundManager.shared.playSoundFile(sound.file.path, sprite) }
        else { SoundManager.shared.playSoundFileWithStartTime(sound.file.path, sprite, milliseconds) }
        return true
    }
    public override func restart() { played = false; super.restart() }
}

public final class ChangeBrightnessByNAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite,
              let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setBrightness"] as? Formula,
              let value = try? formula.interpretFloat(scope) else { return true }
        sprite.look.changeBrightnessInUserInterfaceDimensionUnit(value)
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class ChangeColorByNAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite,
              let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setColor"] as? Formula,
              let value = try? formula.interpretFloat(scope) else { return true }
        sprite.look.changeColorInUserInterfaceDimensionUnit(value)
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class GoToRandomPositionAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite else { return true }
        // Catroid stage dimensions are centered around the origin; keep the random target
        // within the visible user-interface coordinate area.
        let x = Float.random(in: -240...240)
        let y = Float.random(in: -180...180)
        sprite.look.setPositionInUserInterfaceDimensionUnit(x, y)
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class GoToOtherSpritePositionAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite,
              let destination = configuration["setDestinationSprite"] as? Sprite else { return true }
        sprite.look.setPositionInUserInterfaceDimensionUnit(destination.look.xInUserInterfaceDimensionUnit,
                                                             destination.look.yInUserInterfaceDimensionUnit)
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class IfOnEdgeBounceAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite else { return true }
        guard let look = sprite.look else { return true }
        let halfWidth = Float(StageListener.shared.stage.virtualWidth) / 2
        let halfHeight = Float(StageListener.shared.stage.virtualHeight) / 2
        let x = look.xInUserInterfaceDimensionUnit
        let y = look.yInUserInterfaceDimensionUnit
        let maxX = max(0, halfWidth - look.widthInUserInterfaceDimensionUnit / 2)
        let maxY = max(0, halfHeight - look.heightInUserInterfaceDimensionUnit / 2)
        var direction = look.motionDirectionInUserInterfaceDimensionUnit
        if x > maxX || x < -maxX { direction = 180 - direction }
        if y > maxY || y < -maxY { direction = -direction }
        direction.formTruncatingRemainder(dividingBy: 360)
        look.setMotionDirectionInUserInterfaceDimensionUnit(direction)
        look.setPositionInUserInterfaceDimensionUnit(min(max(x, -maxX), maxX), min(max(y, -maxY), maxY))
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class StartPlotAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        if let sprite = configuration["setSprite"] as? Sprite { sprite.plot.resumePlot() }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class StopPlotAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        if let sprite = configuration["setSprite"] as? Sprite { sprite.plot.pausePlot() }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class StartEngraveAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        if let sprite = configuration["setSprite"] as? Sprite { sprite.plot.resumeEngrave() }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class StopEngraveAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        if let sprite = configuration["setSprite"] as? Sprite { sprite.plot.pauseEngrave() }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class StartCutAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        if let sprite = configuration["setSprite"] as? Sprite { sprite.plot.resumeCut() }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class StopCutAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        if let sprite = configuration["setSprite"] as? Sprite { sprite.plot.pauseCut() }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class ArcAction: TemporalAction {
    private var scope: Scope?
    private var direction: ArcBrick.Directions = .LEFT
    private var radiusFormula: Formula?
    private var degreesFormula: Formula?
    private var centerX = 0.0, centerY = 0.0, startAngle = 0.0
    private var signedDegrees = 0.0, radiusValue = 0.0
    public required init() { super.init() }
    public func setScope(_ value: Scope) { scope = value }
    public func setDirection(_ value: ArcBrick.Directions) { direction = value }
    public func setRadius(_ value: Formula) { radiusFormula = value }
    public func setDegrees(_ value: Formula) { degreesFormula = value }
    public func setInterpolation(_ value: Interpolation?) { /* Geometry action currently uses its native curve. */ }
    public override func begin() {
        guard let scope = scope,
              let degrees = degreesFormula, let radius = radiusFormula,
              let interpretedDegrees = try? degrees.interpretDouble(scope),
              let interpretedRadius = try? radius.interpretDouble(scope) else { return }
        let effectiveLeft = (interpretedDegrees < 0) ? direction != .LEFT : direction == .LEFT
        signedDegrees = abs(interpretedDegrees) * (effectiveLeft ? 1 : -1)
        radiusValue = abs(interpretedRadius)
        guard let look = scope.sprite.look else { return }
        let x = Double(look.xInUserInterfaceDimensionUnit), y = Double(look.yInUserInterfaceDimensionUnit)
        let motion = Double(look.motionDirectionInUserInterfaceDimensionUnit) * Double.pi / 180
        centerX = x + radiusValue * (effectiveLeft ? -cos(motion) : cos(motion))
        centerY = y + radiusValue * (effectiveLeft ? sin(motion) : -sin(motion))
        startAngle = atan2(y - centerY, x - centerX)
    }
    public override func update(_ percent: Float) {
        guard let scope = scope else { return }
        let radians = signedDegrees * Double(percent) * Double.pi / 180
        let x = centerX + radiusValue * cos(startAngle + radians)
        let y = centerY + radiusValue * sin(startAngle + radians)
        scope.sprite.look.setPositionInUserInterfaceDimensionUnit(Float(x), Float(y))
    }
    public override func restart() { super.restart(); centerX = 0; centerY = 0; startAngle = 0; signedDegrees = 0; radiusValue = 0 }
}

public final class GoThroughAction: TemporalAction {
    private var scope: Scope?
    private var x1: Formula?, y1: Formula?, x2: Formula?, y2: Formula?
    private var startX = 0.0, startY = 0.0, anchorX = 0.0, anchorY = 0.0, endX = 0.0, endY = 0.0
    public required init() { super.init() }
    public func setScope(_ value: Scope) { scope = value }
    public func setTargetCoordinates(_ x1: Formula, _ y1: Formula, _ x2: Formula, _ y2: Formula) { self.x1 = x1; self.y1 = y1; self.x2 = x2; self.y2 = y2 }
    public func setInterpolation(_ value: Interpolation?) { /* Geometry action currently uses its native curve. */ }
    public override func begin() {
        guard let scope = scope, let x1 = x1, let y1 = y1, let x2 = x2, let y2 = y2,
              let throughX = try? x1.interpretDouble(scope), let throughY = try? y1.interpretDouble(scope),
              let endX = try? x2.interpretDouble(scope), let endY = try? y2.interpretDouble(scope) else { return }
        startX = Double(scope.sprite.look.xInUserInterfaceDimensionUnit); startY = Double(scope.sprite.look.yInUserInterfaceDimensionUnit)
        self.endX = endX; self.endY = endY
        anchorX = 2 * throughX - (startX + endX) / 2
        anchorY = 2 * throughY - (startY + endY) / 2
    }
    public override func update(_ percent: Float) {
        guard let scope = scope else { return }
        let t = Double(percent), inverse = 1 - t
        let x = inverse * inverse * startX + 2 * inverse * t * anchorX + t * t * endX
        let y = inverse * inverse * startY + 2 * inverse * t * anchorY + t * t * endY
        scope.sprite.look.setPositionInUserInterfaceDimensionUnit(Float(x), Float(y))
    }
    public override func restart() { super.restart(); startX = 0; startY = 0; anchorX = 0; anchorY = 0; endX = 0; endY = 0 }
}

public final class SetCameraFocusPointAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite,
              let scope = configuration["setScope"] as? Scope else { return true }
        let horizontal = (configuration["setHorizontal"] as? Formula).flatMap { try? $0.interpretFloat(scope) } ?? 0
        let vertical = (configuration["setVertical"] as? Formula).flatMap { try? $0.interpretFloat(scope) } ?? 0
        StageListener.shared.focusCamera(on: sprite, horizontalFlex: horizontal, verticalFlex: vertical)
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class PlaySoundAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var hasPlayed = false
    public override func act(_ delta: Float) -> Bool {
        guard !hasPlayed else { return true }
        hasPlayed = true
        guard let sprite = configuration["setSprite"] as? Sprite,
              let sound = configuration["setSound"] as? SoundInfo,
              sprite.soundList.contains(where: { $0 === sound }) else { return true }
        if sound.isMidiFile { MidiSoundManager.shared.playSoundFile(sound.file.path, sprite) }
        else { SoundManager.shared.playSoundFile(sound.file.path, sprite) }
        return true
    }
    public override func restart() { hasPlayed = false; super.restart() }
}

public final class StopSoundAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var hasStopped = false
    public override func act(_ delta: Float) -> Bool {
        guard !hasStopped else { return true }
        hasStopped = true
        guard let sprite = configuration["setSprite"] as? Sprite,
              let sound = configuration["setSound"] as? SoundInfo else { return true }
        if sound.isMidiFile { MidiSoundManager.shared.stopSoundFile(sound.file.path, sprite) }
        else { SoundManager.shared.stopSoundFile(sound.file.path, sprite) }
        return true
    }
    public override func restart() { hasStopped = false; super.restart() }
}

public final class CloneAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        if let sprite = configuration["setSprite"] as? Sprite {
            StageListener.shared.stage.cloneSprite(sprite)
        }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class SetBrightnessAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite,
              let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setBrightness"] as? Formula,
              let value = try? formula.interpretFloat(scope) else { return true }
        sprite.look.setBrightnessInUserInterfaceDimensionUnit(value)
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class SetLookAction: IOSMissingEventActionAdapter {
public required override init() { super.init() }
    public override var receivingSprites: [Sprite] {
        guard let sprite = configuration["setSprite"] as? Sprite else { return [] }
        return [sprite]
    }
    public override func getEventId() -> EventId? {
        guard let sprite = configuration["setSprite"] as? Sprite,
              let lookData = configuration["setLookData"] as? LookData,
              sprite.lookList.contains(where: { $0 === lookData }) else { return nil }
        sprite.look.setLookData(lookData)
        return SetLookEventId(sprite: sprite, look: lookData)
    }
}

public final class SetLookByIndexAction: IOSMissingEventActionAdapter {
public required override init() { super.init() }
    public override var receivingSprites: [Sprite] {
        guard let sprite = configuration["setSprite"] as? Sprite else { return [] }
        return [sprite]
    }
    public override func getEventId() -> EventId? {
        guard let sprite = configuration["setSprite"] as? Sprite,
              let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let index = try? formula.interpretInteger(scope),
              index > 0, index <= sprite.lookList.count else { return nil }
        let data = sprite.lookList[index - 1]
        sprite.look.setLookData(data)
        return SetLookEventId(sprite: sprite, look: data)
    }
}

public final class SetPreviousLookAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite, !sprite.lookList.isEmpty else { return true }
        if let current = sprite.look.lookData, let index = sprite.lookList.firstIndex(where: { $0 === current }) {
            sprite.look.setLookData(sprite.lookList[(index - 1 + sprite.lookList.count) % sprite.lookList.count])
        } else if let last = sprite.lookList.last { sprite.look.setLookData(last) }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class DeleteLookAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite,
              let current = sprite.look.lookData,
              let index = sprite.lookList.firstIndex(where: { $0 === current }) else { return true }
        if sprite.lookList.count > 1 { sprite.lookList.remove(at: index); sprite.look.setLookData(sprite.lookList[min(index, sprite.lookList.count - 1)]) }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class SpeakAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    public convenience init(scope: Scope, text: Formula) {
        self.init(); store("setScope", scope); store("setFormula", text)
    }
    private var spoken = false
    public override func act(_ delta: Float) -> Bool {
        guard !spoken else { return true }; spoken = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let text = try? formula.interpretString(scope) else { return true }
        IOSSpeechService.shared.speak(text, language: nil)
        return true
    }
    public override func restart() { spoken = false; super.restart() }
}

public final class SpeakAndWaitAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    public convenience init(scope: Scope, text: Formula) {
        self.init(); store("setScope", scope); store("setFormula", text)
    }
    private var utteranceID: UUID?
    private var started = false
    public override func act(_ delta: Float) -> Bool {
        if !started {
            started = true
            guard let scope = configuration["setScope"] as? Scope,
                  let formula = configuration["setFormula"] as? Formula,
                  let text = try? formula.interpretString(scope) else { return true }
            utteranceID = IOSSpeechService.shared.speak(text, language: nil)
            return text.isEmpty
        }
        guard let id = utteranceID else { return true }
        return IOSSpeechService.shared.isFinished(id)
    }
    public override func restart() { utteranceID = nil; started = false; super.restart() }
}

public final class PauseForBeatsAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var elapsed: Float = 0
    private var duration: Float = 0
    private var initializedDuration = false
    public override func act(_ delta: Float) -> Bool {
        if !initializedDuration {
            initializedDuration = true
            if let scope = configuration["setScope"] as? Scope,
               let beats = configuration["setBeats"] as? Formula,
               let value = try? beats.interpretFloat(scope) {
                duration = max(0, (value * 60 / max(1, MidiSoundManager.shared.tempo)))
            }
        }
        elapsed += delta
        return elapsed >= duration
    }
    public override func restart() { elapsed = 0; duration = 0; initializedDuration = false; super.restart() }
}

public final class ChangeTempoByAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setTempo"] as? Formula,
              let value = try? formula.interpretFloat(scope) else { return true }
        MidiSoundManager.shared.setTempo(MidiSoundManager.shared.tempo + value)
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class ChangeVariableAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let variable = configuration["setUserVariable"] as? UserVariable,
              let formula = configuration["setChangeVariable"] as? Formula,
              let scope = configuration["setScope"] as? Scope else { return true }
        let rhs = formula.interpretObject(scope)
        if let a = variable.value as? Double {
            let b = (rhs as? Double) ?? Double((rhs as? String) ?? "") ?? 0
            variable.value = (a.isFinite ? a : 0) + (b.isFinite ? b : 0)
        } else if let a = variable.value as? String {
            variable.value = a + String(describing: rhs)
        } else {
            variable.value = rhs
        }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class SetVariableAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let variable = configuration["setUserVariable"] as? UserVariable,
              let formula = configuration["setChangeVariable"] as? Formula,
              let scope = configuration["setScope"] as? Scope else { return true }
        variable.value = formula.interpretObject(scope)
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class AskAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var presented = false
    private var answered = false
    public override func act(_ delta: Float) -> Bool {
        if answered { return true }
        guard !presented else { return false }
        presented = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setQuestionFormula"] as? Formula,
              let variable = configuration["setAnswerVariable"] as? UserVariable else { answered = true; return true }
        let question = (try? formula.interpretString(scope)) ?? ""
        DispatchQueue.main.async { [weak self] in
            guard let controller = StageViewController.activeStage else { self?.answered = true; return }
            let alert = UIAlertController(title: question, message: nil, preferredStyle: .alert)
            alert.addTextField { $0.clearButtonMode = .whileEditing }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in self?.answered = true })
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                variable.value = alert.textFields?.first?.text ?? ""
                self?.answered = true
            })
            controller.present(alert, animated: true)
        }
        return false
    }
    public override func restart() { presented = false; answered = false; super.restart() }
}

public final class AskSpeechAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var started = false
    private var finished = false
    private var audioEngine: AVAudioEngine?
    private var task: SFSpeechRecognitionTask?
    public override func act(_ delta: Float) -> Bool {
        if finished { return true }
        if !started { started = true; startRecognition() }
        return finished
    }
    private func startRecognition() {
        guard let scope = configuration["setScope"] as? Scope,
              let questionFormula = configuration["setQuestionFormula"] as? Formula,
              let variable = configuration["setAnswerVariable"] as? UserVariable else { finished = true; return }
        let question = (try? questionFormula.interpretString(scope)) ?? ""
        DispatchQueue.main.async { [weak self] in
            guard let controller = StageViewController.activeStage else { self?.finished = true; return }
            let alert = UIAlertController(title: question.isEmpty ? "Speak now" : question, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in self?.finished = true })
            controller.present(alert, animated: true) { self?.beginSpeechRecognition(variable: variable) }
        }
    }
    private func beginSpeechRecognition(variable: UserVariable) {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            guard let self = self, status == .authorized else { self?.finished = true; return }
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted else { self.finished = true; return }
                DispatchQueue.main.async {
                    let locale = Locale(identifier: IOSSpeechPreferences.languageTag.isEmpty ? Locale.current.identifier : IOSSpeechPreferences.languageTag)
                    guard let recognizer = SFSpeechRecognizer(locale: locale), recognizer.isAvailable else { self.finished = true; return }
                    let engine = AVAudioEngine(); let request = SFSpeechAudioBufferRecognitionRequest()
                    let input = engine.inputNode
                    input.installTap(onBus: 0, bufferSize: 1024, format: input.outputFormat(forBus: 0)) { buffer, _ in request.append(buffer) }
                    do { engine.prepare(); try engine.start() } catch { input.removeTap(onBus: 0); self.finished = true; return }
                    self.audioEngine = engine
                    self.task = recognizer.recognitionTask(with: request) { [weak self] result, error in
                        if let result = result { variable.value = result.bestTranscription.formattedString; if result.isFinal { self?.stopRecognition() } }
                        if error != nil { self?.stopRecognition() }
                    }
                }
            }
        }
    }
    private func stopRecognition() { audioEngine?.stop(); audioEngine?.inputNode.removeTap(onBus: 0); audioEngine = nil; task?.cancel(); task = nil; finished = true }
    public override func restart() { stopRecognition(); started = false; finished = false; super.restart() }
}

public final class DeleteItemOfUserListAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let list = configuration["setUserList"] as? UserList,
              let formula = configuration["setFormulaIndexToDelete"] as? Formula,
              let scope = configuration["setScope"] as? Scope,
              let index = try? formula.interpretInteger(scope) else { return true }
        if index > 0 && index <= list.value.count { list.value.remove(at: index - 1) }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class AddItemToUserListAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let list = configuration["setUserList"] as? UserList,
              let formula = configuration["setFormulaItemToAdd"] as? Formula,
              let scope = configuration["setScope"] as? Scope else { return true }
        list.addListItem(formula.interpretObject(scope))
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class InsertItemIntoUserListAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let list = configuration["setUserList"] as? UserList,
              let indexFormula = configuration["setFormulaIndexToInsert"] as? Formula,
              let itemFormula = configuration["setFormulaItemToInsert"] as? Formula,
              let scope = configuration["setScope"] as? Scope,
              let index = try? indexFormula.interpretInteger(scope) else { return true }
        list.value.insert(itemFormula.interpretObject(scope), at: max(0, min(list.value.count, index - 1)))
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class StoreCSVIntoUserListAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let list = configuration["setUserList"] as? UserList,
              let columnFormula = configuration["setFormulaColumnToExtract"] as? Formula,
              let csvFormula = configuration["setFormulaCSVData"] as? Formula,
              let scope = configuration["setScope"] as? Scope,
              let column = try? columnFormula.interpretInteger(scope), column > 0 else { return true }
        let csv = (try? csvFormula.interpretString(scope)) ?? ""
        list.value = csv.split(whereSeparator: \.isNewline).compactMap { line in
            let cells = line.split(separator: ",", omittingEmptySubsequences: false).map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            guard column <= cells.count else { return nil }
            return cells[column - 1] as Any
        }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class ReplaceItemInUserListAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let list = configuration["setUserList"] as? UserList,
              let indexFormula = configuration["setFormulaIndexToReplace"] as? Formula,
              let itemFormula = configuration["setFormulaItemToInsert"] as? Formula,
              let scope = configuration["setScope"] as? Scope,
              let index = try? indexFormula.interpretInteger(scope) else { return true }
        if index > 0 && index <= list.value.count { list.value[index - 1] = itemFormula.interpretObject(scope) }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class SceneStartAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var started = false
    public override func act(_ delta: Float) -> Bool {
        guard !started else { return true }; started = true
        guard let sceneName = configuration["setScene"] as? String else { return true }
        StageListener.shared.transitionToScene(sceneName)
        return true
    }
    public override func restart() { started = false; super.restart() }
}

public final class IfLogicAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var selected: Action?
    public override func act(_ delta: Float) -> Bool {
        if selected == nil {
            guard let condition = configuration["setIfCondition"] as? Formula,
                  let scope = configuration["setScope"] as? Scope else { return true }
            let result = (try? condition.interpretBoolean(scope)) ?? false
            selected = result ? (configuration["setIfAction"] as? Action) : (configuration["setElseAction"] as? Action)
            guard selected != nil else { return true }
        }
        return selected?.act(delta) ?? true
    }
    public func setIfAction(_ value: Action) { store("setIfAction", value) }
    public func setElseAction(_ value: Action?) { store("setElseAction", value as Any) }
    public func setIfCondition(_ value: Formula) { store("setIfCondition", value) }
    public func setScope(_ value: Scope) { store("setScope", value) }
    public override func restart() { selected = nil; super.restart() }
}

public final class RepeatAction: IOSMissingLoopActionAdapter {
public required override init() { super.init() }
    private var initializedCount = false
    private var count = 0
    private var completed = 0
    private var loopStarted = false
    public override func delegate(_ delta: Float) -> Bool {
        guard let child = action else { return true }
        if !initializedCount {
            initializedCount = true
            if (configuration["setActive"] as? Bool) == true { count = Int.max }
            else if let formula = configuration["setRepeatCount"] as? Formula,
                    let scope = configuration["setScope"] as? Scope,
                    let value = try? formula.interpretInteger(scope) { count = max(0, value) }
            else { count = 0 }
        }
        if completed >= count { return true }
        currentTime += delta
        if child.act(delta) && !isLoopDelayNeeded() {
            completed += 1
            if completed >= count { return true }
            loopStarted = false
            child.restart()
            currentTime = 0
        }
        loopStarted = true
        return false
    }
    public func setRepeatCount(_ value: Formula) { store("setRepeatCount", value) }
    public func setForeverRepeat(_ value: Bool) { store("setActive", value) }
    public func setScope(_ value: Scope) { store("setScope", value) }
    public override func restart() {
        initializedCount = false; count = 0; completed = 0; loopStarted = false
        super.restart()
    }
}

public final class RepeatUntilAction: IOSMissingLoopActionAdapter {
public required override init() { super.init() }
    public override func delegate(_ delta: Float) -> Bool {
        guard let child = action else { return true }
        if let condition = configuration["setRepeatCondition"] as? Formula,
           let scope = configuration["setScope"] as? Scope,
           (try? condition.interpretBoolean(scope)) == true { return true }
        currentTime += delta
        if child.act(delta) && !isLoopDelayNeeded() {
            child.restart(); currentTime = 0
        }
        return false
    }
    public func setRepeatCondition(_ value: Formula) { store("setRepeatCondition", value) }
    public func setScope(_ value: Scope) { store("setScope", value) }
}

public final class WriteEmbroideryToFileAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var attempted = false
    public override func act(_ delta: Float) -> Bool {
        guard !attempted else { return true }; attempted = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let rawName = try? formula.interpretString(scope) else { return true }
        let clean = IOSFileTools.safeFileName(rawName)
        let fileName = clean.lowercased().hasSuffix(".dst") ? clean : clean + ".dst"
        let url = IOSFileTools.exportDirectory().appendingPathComponent(fileName)
        do {
            try EmbroideryPatternManager.shared.writeDST(to: url, label: scope.project?.name ?? "Catroid")
            IOSActionAlerts.share(url)
        } catch {
            IOSActionAlerts.show(title: "Embroidery export failed", message: error.localizedDescription)
        }
        return true
    }
    public override func restart() { attempted = false; super.restart() }
}

public final class SavePlotAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var saved = false
    public override func act(_ delta: Float) -> Bool {
        guard !saved else { return true }; saved = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let name = try? formula.interpretString(scope) else { return true }
        _ = IOSPlotExport.writeSVG(points: scope.sprite.plot.plotDataPointLists, name: name)
        return true
    }
    public override func restart() { saved = false; super.restart() }
}

public final class SaveLaserAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var saved = false
    public override func act(_ delta: Float) -> Bool {
        guard !saved else { return true }; saved = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let name = try? formula.interpretString(scope) else { return true }
        _ = IOSPlotExport.writeSVG(points: scope.sprite.plot.cutDataPointLists, name: name)
        return true
    }
    public override func restart() { saved = false; super.restart() }
}

public final class SharePlotAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var shared = false
    public override func act(_ delta: Float) -> Bool {
        guard !shared else { return true }; shared = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let name = try? formula.interpretString(scope),
              let url = IOSPlotExport.writeSVG(points: scope.sprite.plot.plotDataPointLists, name: name) else { return true }
        IOSActionAlerts.share(url)
        return true
    }
    public override func restart() { shared = false; super.restart() }
}

public final class ShareLaserAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var shared = false
    public override func act(_ delta: Float) -> Bool {
        guard !shared else { return true }; shared = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let name = try? formula.interpretString(scope),
              let url = IOSPlotExport.writeSVG(points: scope.sprite.plot.cutDataPointLists, name: name) else { return true }
        IOSActionAlerts.share(url)
        return true
    }
    public override func restart() { shared = false; super.restart() }
}

public final class ShowTextAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var shownActor: ShowTextActor?
    private var applied = false
    public func setVariableToShow(_ value: UserVariable) { store("setVariableToShow", value) }
    public func setPosition(_ x: Formula, _ y: Formula) { store("positionX", x); store("positionY", y) }
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { shownActor?.updateVariables(); return true }
        applied = true
        guard let variable = configuration["setVariableToShow"] as? UserVariable,
              let scope = configuration["setScope"] as? Scope,
              let xFormula = configuration["positionX"] as? Formula,
              let yFormula = configuration["positionY"] as? Formula,
              let x = try? xFormula.interpretInteger(scope),
              let y = try? yFormula.interpretInteger(scope) else { return true }
        variable.setVisible(true)
        for node in StageListener.shared.stage.textNodes {
            if let old = node as? ShowTextActor,
               old.variableNameToCompare == variable.name, old.sprite === scope.sprite {
                StageListener.shared.stage.removeTextNode(old)
            }
        }
        let textActor = ShowTextActor(userVariable: variable, xPosition: x, yPosition: y,
                                      relativeSize: 1, color: "#FFFFFF", sprite: scope.sprite)
        shownActor = textActor
        StageListener.shared.addActor(textActor)
        textActor.updateVariables()
        return true
    }
    public override func restart() { applied = false; shownActor = nil; super.restart() }
}

public final class FlashAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        IOSCameraService.shared.setTorchEnabled((configuration["setFlashOn"] as? Bool) ?? false)
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class VibrateAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        DispatchQueue.main.async { UIImpactFeedbackGenerator(style: .medium).impactOccurred() }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class CameraBrickAction: TemporalAction {
    public var active = false
    private var appliedState: Bool?
    public required init() { super.init() }
    public func setActive(_ active: Bool) { self.active = active }
    public override func update(_ percent: Float) {
        guard appliedState != active else { return }
        appliedState = active
        IOSCameraService.shared.setPreviewEnabled(active)
    }
    public override func restart() { appliedState = nil; super.restart() }
}

public final class FadeParticleEffectAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite else { return true }
        let enabled = (configuration["setFadeIn"] as? Bool) ?? false
        sprite.look.hasParticleEffect = enabled
        sprite.look.isAdditive = false
        if enabled { sprite.look.resumeParticleEffect() }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class AdditiveParticleEffectAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let sprite = configuration["setSprite"] as? Sprite else { return true }
        let enabled = (configuration["setFadeIn"] as? Bool) ?? false
        sprite.look.hasParticleEffect = enabled
        sprite.look.isAdditive = true
        if enabled { sprite.look.resumeParticleEffect() }
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class SetParticleColorAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setColor"] as? Formula,
              let text = try? formula.interpretString(scope) else { return true }
        let color = IOSColorTools.color(from: text)
        scope.sprite.look.particleEmitter.particleColor = color
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class ChooseCameraAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    public func setFrontCamera() { store("setFrontCamera", true) }
    public func setBackCamera() { store("setBackCamera", true) }
    public override func act(_ delta: Float) -> Bool {
        IOSCameraService.shared.selectFrontCamera((configuration["setFrontCamera"] as? Bool) == true)
        return true
    }
}

public final class AssertEqualsAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var evaluated = false
    public override func act(_ delta: Float) -> Bool {
        guard !evaluated else { return true }; evaluated = true
        guard let scope = configuration["setScope"] as? Scope else { return true }
        guard let actual = configuration["setActualFormula"] as? Formula else {
            StageActivity.finishTestWithResult(TestResult(message: "AssertEqualsError\nActual is null", resultCode: TestResult.stageActivityTestFail)); return false
        }
        guard let expected = configuration["setExpectedFormula"] as? Formula else {
            StageActivity.finishTestWithResult(TestResult(message: "AssertEqualsError\nExpected is null", resultCode: TestResult.stageActivityTestFail)); return false
        }
        let actualValue = actual.interpretObject(scope)
        let expectedValue = expected.interpretObject(scope)
        if Self.equal(actualValue, expectedValue) { return true }
        let a = String(describing: actualValue), e = String(describing: expectedValue)
        let prefix = Self.commonPrefixLength(a, e)
        let indicator = String(repeating: "-", count: prefix) + "^"
        let position = (configuration["setPosition"] as? String) ?? ""
        StageActivity.finishTestWithResult(TestResult(message: "on sprite \"\(scope.sprite.name)\"\n\(position)\nAssertEqualsError\nexpected: <\(e)>\nactual:   <\(a)>\ndeviation: \(indicator)", resultCode: TestResult.stageActivityTestFail))
        return false
    }
    private static func equal(_ lhs: Any, _ rhs: Any) -> Bool {
        let a = String(describing: lhs), b = String(describing: rhs)
        if a == b { return true }
        if let x = Double(a), let y = Double(b) { return x == y }
        return false
    }
    fileprivate static func commonPrefixLength(_ lhs: String, _ rhs: String) -> Int {
        var count = 0
        for (a, b) in zip(lhs, rhs) { if a != b { break }; count += 1 }
        return count
    }
    public override func restart() { evaluated = false; super.restart() }
}

public final class AssertUserListAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var evaluated = false
    public override func act(_ delta: Float) -> Bool {
        guard !evaluated else { return true }; evaluated = true
        guard let actual = configuration["setActualUserList"] as? UserList else {
            StageActivity.finishTestWithResult(TestResult(message: "AssertUserListError\nActual list is null", resultCode: TestResult.stageActivityTestFail)); return false
        }
        guard let expected = configuration["setExpectedUserList"] as? UserList else {
            StageActivity.finishTestWithResult(TestResult(message: "AssertUserListError\nExpected list is null", resultCode: TestResult.stageActivityTestFail)); return false
        }
        var errors: [String] = []
        if actual.value.count != expected.value.count {
            errors.append("The number of list elements are not equal\nexpected: \(expected.value.count) element/s\nactual:   \(actual.value.count) element/s")
        }
        for index in 0..<min(actual.value.count, expected.value.count) {
            let a = String(describing: actual.value[index]), e = String(describing: expected.value[index])
            if a != e && !(Double(a) != nil && Double(a) == Double(e)) {
                let prefix = commonPrefixLength(a, e)
                errors.append("position: \(index + 1)\nexpected: <\(e)>\nactual:   <\(a)>\ndeviation: \(String(repeating: "-", count: prefix))^")
            }
        }
        guard !errors.isEmpty else { return true }
        let scope = configuration["setScope"] as? Scope
        let position = (configuration["setPosition"] as? String) ?? ""
        StageActivity.finishTestWithResult(TestResult(message: "on sprite \"\(scope?.sprite.name ?? "?")\"\n\(position)\nAssertUserListError\n" + errors.joined(separator: "\n\n"), resultCode: TestResult.stageActivityTestFail))
        return false
    }
    private func commonPrefixLength(_ lhs: String, _ rhs: String) -> Int {
        var count = 0
        for (a, b) in zip(lhs, rhs) { if a != b { break }; count += 1 }
        return count
    }
    public override func restart() { evaluated = false; super.restart() }
}

public final class RepeatParameterizedAction: IOSMissingLoopActionAdapter {
    public required override init() { super.init() }
    private var initialized = false
    private var finished = false
    private var currentIndex = 0
    public override func delegate(_ delta: Float) -> Bool {
        guard !finished else { return true }
        guard let data = configuration["setParameterizedData"] as? ParameterizedData,
              let parameters = configuration["setParameters"] as? [(UserList, UserVariable)],
              !parameters.isEmpty, let child = action else {
            StageActivity.finishTestWithResult(TestResult(message: "ParameterizedInitialisationError\nInput was not selected", resultCode: TestResult.stageActivityTestFail)); finished = true; return true
        }
        if !initialized {
            currentIndex = data.currentPosition
            data.listSize = parameters.map({ $0.0.value.count }).min() ?? 0
            if currentIndex >= data.listSize { finished = true; return true }
            data.currentParameters = "[\(currentIndex + 1)] "
            for (list, variable) in parameters {
                guard currentIndex < list.value.count else {
                    StageActivity.finishTestWithResult(TestResult(message: "ParameterizedInitialisationError\nInput list is missing elements", resultCode: TestResult.stageActivityTestFail)); finished = true; return true
                }
                variable.value = list.value[currentIndex]
                data.currentParameters += "\(variable.name) = \(variable.value) | "
            }
            data.currentParameters = String(data.currentParameters.dropLast(3))
            initialized = true
            currentTime = 0
        }
        currentTime += delta
        if child.act(delta) && !isLoopDelayNeeded() {
            currentIndex = data.currentPosition
            if currentIndex >= data.listSize { finished = true; return true }
            initialized = false; child.restart(); currentTime = 0
        }
        return false
    }
    public override func restart() { initialized = false; finished = false; currentIndex = 0; (configuration["setParameterizedData"] as? ParameterizedData)?.reset(); super.restart() }
} 

public final class ParameterizedAssertAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var evaluated = false
    public override func act(_ delta: Float) -> Bool {
        guard !evaluated else { return true }; evaluated = true
        guard let scope = configuration["setScope"] as? Scope,
              let actualFormula = configuration["setActualFormula"] as? Formula,
              let expected = configuration["setExpectedList"] as? UserList,
              let data = configuration["setParameterizedData"] as? ParameterizedData else { return true }
        let actual = String(describing: actualFormula.interpretObject(scope))
        let index = data.currentPosition
        let expectedValue = index < expected.value.count ? String(describing: expected.value[index]) : "null"
        let equal = actual == expectedValue || (Double(actual) != nil && Double(actual) == Double(expectedValue))
        if equal { data.successMessages.append("\n\(data.currentParameters)\n\(actual) == \(expectedValue)\n") }
        else { data.failMessages.append("\n\(data.currentParameters)\nexpected: <\(expectedValue)>\nactual:   <\(actual)>\n") }
        data.currentPosition += 1
        data.currentParameters = ""
        if !data.failMessages.isEmpty && data.currentPosition >= expected.value.count {
            StageActivity.finishTestWithResult(TestResult(message: "Failed Tests:\n\(data.failMessages)\nSucceeded Tests:\n\(data.successMessages)", resultCode: TestResult.stageActivityTestFail))
        }
        return true
    }
    public override func restart() { evaluated = false; super.restart() }
}

public final class FinishStageAction: IOSMissingActionAdapter {
public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        StageActivity.finishStage()
        return true
    }
    public override func restart() { applied = false; super.restart() }
}

public final class TapAtAction: TemporalAction {
    public required init() { super.init() }
    private var scope: Scope?
    private var startX: Formula?
    private var startY: Formula?
    private var changeX: Formula?
    private var changeY: Formula?
    private var durationFormula: Formula?
    private var pointer = -1
    private var startPoint = CGPoint.zero
    private var endPoint = CGPoint.zero
    private var failed = false
    public func setScope(_ value: Scope) { scope = value }
    public func setStartX(_ value: Formula) { startX = value }
    public func setStartY(_ value: Formula) { startY = value }
    public func setChangeX(_ value: Formula) { changeX = value }
    public func setChangeY(_ value: Formula) { changeY = value }
    public func setDurationFormula(_ value: Formula) { durationFormula = value }
    public override func begin() {
        guard let scope = scope, let xFormula = startX, let yFormula = startY,
              let x = try? xFormula.interpretFloat(scope), let y = try? yFormula.interpretFloat(scope) else { failed = true; setDuration(0); return }
        startPoint = CGPoint(x: CGFloat(x), y: CGFloat(y)); endPoint = startPoint
        if let xf = changeX, let yf = changeY, let ex = try? xf.interpretFloat(scope), let ey = try? yf.interpretFloat(scope) { endPoint = CGPoint(x: CGFloat(ex), y: CGFloat(ey)) }
        if let durationFormula = durationFormula, let duration = try? durationFormula.interpretFloat(scope) { setDuration(max(0, duration)) } else { setDuration(0) }
        pointer = scope.sprite.getUnusedPointer()
        TouchUtil.touchDown(x: Float(startPoint.x), y: Float(startPoint.y), pointer: pointer)
    }
    public override func update(_ percent: Float) {
        guard !failed, pointer >= 0 else { return }
        let x = Float(startPoint.x + (endPoint.x - startPoint.x) * CGFloat(percent))
        let y = Float(startPoint.y + (endPoint.y - startPoint.y) * CGFloat(percent))
        TouchUtil.updatePosition(x: x, y: y, pointer: pointer)
    }
    public override func end() { if pointer >= 0 { TouchUtil.touchUp(pointer: pointer); scope?.sprite.releaseUsedPointer(pointer); pointer = -1 } }
    public override func restart() { if pointer >= 0 { TouchUtil.touchUp(pointer: pointer); scope?.sprite.releaseUsedPointer(pointer); pointer = -1 }; failed = false; super.restart() }
}

public final class WriteUserDataOnDeviceAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var written = false
    public override func act(_ delta: Float) -> Bool {
        guard !written else { return true }; written = true
        guard let accessor = configuration["setAccessor"] as? DeviceUserDataAccessor,
              let userData = configuration["setUserData"] else { return true }
        var dictionary = accessor.readDictionary()
        if let variable = userData as? UserVariable { dictionary[variable.name] = variable.value }
        else if let list = userData as? UserList { dictionary[list.name] = list.value }
        accessor.writeDictionary(dictionary)
        return true
    }
    public override func restart() { written = false; super.restart() }
}

public final class WriteVariableToFileAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var written = false
    public override func act(_ delta: Float) -> Bool {
        guard !written else { return true }; written = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let variable = configuration["setUserVariable"] as? UserVariable,
              let rawName = try? formula.interpretString(scope) else { return true }
        let name = IOSFileTools.safeFileName(rawName)
        let destination = IOSFileTools.exportDirectory().appendingPathComponent(name.hasSuffix(".txt") ? name : name + ".txt")
        try? FileManager.default.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? String(describing: variable.value).write(to: destination, atomically: true, encoding: .utf8)
        return true
    }
    public override func restart() { written = false; super.restart() }
}

public final class ReadVariableFromFileAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var read = false
    public override func act(_ delta: Float) -> Bool {
        guard !read else { return true }; read = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let variable = configuration["setUserVariable"] as? UserVariable,
              let rawName = try? formula.interpretString(scope) else { return true }
        let name = IOSFileTools.safeFileName(rawName)
        let path = IOSFileTools.exportDirectory().appendingPathComponent(name.contains(".") ? name : name + ".txt")
        if let content = try? String(contentsOf: path, encoding: .utf8) {
            variable.value = Double(content.trimmingCharacters(in: .whitespacesAndNewlines)) ?? content
            if (configuration["setDeleteFile"] as? Bool) == true { try? FileManager.default.removeItem(at: path) }
        }
        return true
    }
    public override func restart() { read = false; super.restart() }
}

public final class WebRequestAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var requested = false
    private var finished = false
    public override func act(_ delta: Float) -> Bool {
        guard !requested else { return finished }
        requested = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let variable = configuration["setUserVariable"] as? UserVariable,
              let raw = try? formula.interpretString(scope),
              let url = IOSURLTools.url(from: raw) else { finished = true; return true }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let text = String(data: data, encoding: .utf8) { variable.value = text }
            self?.finished = true
        }.resume()
        return false
    }
    public override func restart() { requested = false; finished = false; super.restart() }
}

public final class LookRequestAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var requested = false
    private var finished = false
    public override func act(_ delta: Float) -> Bool {
        guard !requested else { return finished }
        requested = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let raw = try? formula.interpretString(scope),
              let url = IOSURLTools.url(from: raw) else { finished = true; return true }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, _ in
            defer { self?.finished = true }
            guard let data = data, let http = response as? HTTPURLResponse,
                  (200..<300).contains(http.statusCode),
                  let image = UIImage(data: data),
                  let sprite = scope.sprite as Sprite? else { return }
            let destination = FileManager.default.temporaryDirectory.appendingPathComponent("look-\(UUID().uuidString).png")
            guard let png = image.pngData(), (try? png.write(to: destination, options: .atomic)) != nil else { return }
            let look = LookData(name: destination.deletingPathExtension().lastPathComponent, file: destination)
            sprite.lookList.append(look)
            sprite.look.setLookData(look)
        }.resume()
        return false
    }
    public override func restart() { requested = false; finished = false; super.restart() }
}

public final class OpenUrlAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var opened = false
    public override func act(_ delta: Float) -> Bool {
        guard !opened else { return true }; opened = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let raw = try? formula.interpretString(scope),
              let url = IOSURLTools.url(from: raw) else { return true }
        DispatchQueue.main.async { UIApplication.shared.open(url) }
        return true
    }
    public override func restart() { opened = false; super.restart() }
}

public final class StartListeningAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var started = false
    private var finished = false
    private var audioEngine: AVAudioEngine?
    private var recognitionTask: SFSpeechRecognitionTask?
    public override func act(_ delta: Float) -> Bool {
        if finished { return true }
        if !started { started = true; beginListening() }
        return finished
    }
    private func beginListening() {
        guard let variable = configuration["setUserVariable"] as? UserVariable else { finished = true; return }
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            guard let self = self, status == .authorized else { self?.finished = true; return }
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                guard granted else { self.finished = true; return }
                DispatchQueue.main.async { self.startRecognition(into: variable) }
            }
        }
    }
    private func startRecognition(into variable: UserVariable) {
        let locale = Locale(identifier: IOSSpeechPreferences.languageTag.isEmpty ? Locale.current.identifier : IOSSpeechPreferences.languageTag)
        guard let recognizer = SFSpeechRecognizer(locale: locale), recognizer.isAvailable else { finished = true; return }
        let engine = AVAudioEngine()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        let input = engine.inputNode
        input.installTap(onBus: 0, bufferSize: 1024, format: input.outputFormat(forBus: 0)) { buffer, _ in request.append(buffer) }
        do { engine.prepare(); try engine.start() } catch { input.removeTap(onBus: 0); finished = true; return }
        audioEngine = engine
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            if let result = result {
                variable.value = result.bestTranscription.formattedString
                if result.isFinal { self?.stopListening() }
            }
            if error != nil { self?.stopListening() }
        }
    }
    private func stopListening() {
        audioEngine?.stop(); audioEngine?.inputNode.removeTap(onBus: 0); audioEngine = nil
        recognitionTask?.cancel(); recognitionTask = nil; finished = true
    }
    public override func restart() { stopListening(); started = false; finished = false; super.restart() }
}

public final class SetListeningLanguageAction: IOSMissingActionAdapter {
    public var listeningLanguageTag: String = ""
    public required init() { super.init() }
    public func setListeningLanguageTag(_ value: String) { listeningLanguageTag = value; store("setListeningLanguageTag", value) }
    public override func act(_ delta: Float) -> Bool {
        IOSSpeechPreferences.languageTag = listeningLanguageTag.isEmpty ? Locale.current.identifier : listeningLanguageTag
        return true
    }
}

public final class PaintNewLookAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var requested = false
    private var completed = false
    public override func act(_ delta: Float) -> Bool {
        if completed { return true }
        guard !requested else { return false }; requested = true
        guard let scope = configuration["setScope"] as? Scope else { completed = true; return true }
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let controller = StageViewController.activeStage else { self?.completed = true; return }
            IOSLookImagePicker.present(from: controller) { image in
                defer { self.completed = true }
                guard let image = image, let data = image.pngData(), let project = scope.project else { return }
                let baseName: String?
                if let formula = self.configuration["setFormula"] as? Formula { baseName = try? formula.interpretString(scope) }
                else { baseName = nil }
                let proposedName = baseName?.trimmingCharacters(in: .whitespacesAndNewlines)
                let requestedName = (proposedName?.isEmpty == false ? proposedName! : "Look")
                let existing = scope.sprite.lookList.map(\.name)
                var name = requestedName, suffix = 2
                while existing.contains(name) { name = "\(requestedName) \(suffix)"; suffix += 1 }
                let directory = project.directory.appendingPathComponent(Constants.imageDirectoryName, isDirectory: true)
                do {
                    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                    let file = directory.appendingPathComponent("look-\(UUID().uuidString).png")
                    try data.write(to: file, options: .atomic)
                    let look = LookData(name: name, file: file)
                    scope.sprite.lookList.append(look)
                    look.collisionInformation.calculate()
                    scope.sprite.look.setLookData(look)
                    (self.configuration["nextLookAction"] as? SetNextLookAction)?.setSprite(scope.sprite)
                    (self.configuration["nextLookAction"] as? SetNextLookAction)?.setScope(scope)
                } catch { NSLog("Catroid could not import a new look: %@", String(describing: error)) }
            }
        }
        return false
    }
    public override func restart() { requested = false; completed = false; super.restart() }
}

public final class CopyLookAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var applied = false
    public override func act(_ delta: Float) -> Bool {
        guard !applied else { return true }; applied = true
        guard let scope = configuration["setScope"] as? Scope,
              let formula = configuration["setFormula"] as? Formula,
              let current = scope.sprite.look.lookData else { return true }
        let name = (try? formula.interpretString(scope)) ?? "Copy of \(current.name)"
        let copied = current.clone()
        copied.name = Self.uniqueName(name, existing: scope.sprite.lookList.map(\.name))
        let index = scope.sprite.lookList.firstIndex(where: { $0 === current }) ?? (scope.sprite.lookList.count - 1)
        scope.sprite.lookList.insert(copied, at: max(0, index + 1))
        copied.collisionInformation.calculate()
        if let next = configuration["nextLookAction"] as? SetNextLookAction { next.setSprite(scope.sprite); next.setScope(scope) }
        return true
    }
    private static func uniqueName(_ base: String, existing: [String]) -> String {
        if !existing.contains(base) { return base }
        var suffix = 2
        while existing.contains("\(base) \(suffix)") { suffix += 1 }
        return "\(base) \(suffix)"
    }
    public override func restart() { applied = false; super.restart() }
}

public final class EditLookAction: IOSMissingActionAdapter {
    public required init() { super.init() }
    private var requested = false
    private var completed = false
    public override func act(_ delta: Float) -> Bool {
        if completed { return true }
        guard !requested else { return false }; requested = true
        guard let scope = configuration["setScope"] as? Scope,
              let current = scope.sprite.look.lookData else { completed = true; return true }
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let controller = StageViewController.activeStage else { self?.completed = true; return }
            IOSLookImagePicker.present(from: controller) { image in
                defer { self.completed = true }
                guard let image = image, let data = image.pngData(), let project = scope.project else { return }
                let directory = project.directory.appendingPathComponent(Constants.imageDirectoryName, isDirectory: true)
                do {
                    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                    let file = directory.appendingPathComponent("look-edit-\(UUID().uuidString).png")
                    try data.write(to: file, options: .atomic)
                    current.setFile(file)
                    current.invalidateThumbnailBitmap()
                    current.dispose()
                    current.collisionInformation.calculate()
                    scope.sprite.look.setLookData(current)
                    (self.configuration["nextLookAction"] as? SetNextLookAction)?.setSprite(scope.sprite)
                    (self.configuration["nextLookAction"] as? SetNextLookAction)?.setScope(scope)
                } catch { NSLog("Catroid could not replace look image: %@", String(describing: error)) }
            }
        }
        return false
    }
    public override func restart() { requested = false; completed = false; super.restart() }
}

public final class SetNextLookAction: IOSMissingActionAdapter {
    private var sprite: Sprite?
    private var scope: Scope?
    public func setSprite(_ sprite: Sprite) { self.sprite = sprite; store("sprite", sprite) }
    public func setScope(_ scope: Scope) { self.scope = scope; store("scope", scope) }
    public override func act(_ delta: Float) -> Bool {
        guard let sprite = sprite else { return true }
        let looks = sprite.lookList
        guard !looks.isEmpty else { return true }
        if let current = sprite.look.lookData, let index = looks.firstIndex(where: { $0 === current }) {
            sprite.look.setLookData(looks[(index + 1) % looks.count])
        } else { if let first = looks.first { sprite.look.setLookData(first) } }
        return true
    }
}

/// Native image-library picker used by the new-look and edit-look actions.
private final class IOSLookImagePicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private static var retainedDelegates: [ObjectIdentifier: IOSLookImagePicker] = [:]
    private var completion: ((UIImage?) -> Void)?

    static func present(from presenter: UIViewController, completion: @escaping (UIImage?) -> Void) {
        let pickerDelegate = IOSLookImagePicker()
        pickerDelegate.completion = completion
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.photoLibrary) ? .photoLibrary : .savedPhotosAlbum
        picker.mediaTypes = ["public.image"]
        picker.delegate = pickerDelegate
        retainedDelegates[ObjectIdentifier(picker)] = pickerDelegate
        presenter.present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        let key = ObjectIdentifier(picker)
        picker.dismiss(animated: true) {
            self.completion?(image)
            self.completion = nil
            Self.retainedDelegates.removeValue(forKey: key)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        let key = ObjectIdentifier(picker)
        picker.dismiss(animated: true) {
            self.completion?(nil)
            self.completion = nil
            Self.retainedDelegates.removeValue(forKey: key)
        }
    }
}

// Multi-argument setters used by ActionFactory.
public extension IOSMissingActionAdapter {
    func setPosition<T, U>(_ x: T, _ y: U) { store("positionX", x); store("positionY", y) }
    func setTargetCoordinates<A, B, C, D>(_ x1: A, _ y1: B, _ x2: C, _ y2: D) {
        store("x1", x1); store("y1", y1); store("x2", x2); store("y2", y2)
    }
    func nextLookAction(_ action: SetNextLookAction) { store("nextLookAction", action) }
}
public extension IOSMissingEventActionAdapter {
    func setPosition<T, U>(_ x: T, _ y: U) { store("positionX", x); store("positionY", y) }
    func setTargetCoordinates<A, B, C, D>(_ x1: A, _ y1: B, _ x2: C, _ y2: D) {
        store("x1", x1); store("y1", y1); store("x2", x2); store("y2", y2)
    }
    func nextLookAction(_ action: SetNextLookAction) { store("nextLookAction", action) }
}
public extension IOSMissingLoopActionAdapter {
    func setPosition<T, U>(_ x: T, _ y: U) { store("positionX", x); store("positionY", y) }
    func setTargetCoordinates<A, B, C, D>(_ x1: A, _ y1: B, _ x2: C, _ y2: D) {
        store("x1", x1); store("y1", y1); store("x2", x2); store("y2", y2)
    }
}

public extension IOSMissingActionAdapter {
    func setDurationInSeconds<T>(_ value: T) { store("setDurationInSeconds", value) }
    func setRelativeTextSize<T>(_ value: T) { store("setRelativeTextSize", value) }
    func setAlignment<T>(_ value: T) { store("setAlignment", value) }
    func setText<T>(_ value: T) { store("setText", value) }
    func setRed<T>(_ value: T) { store("setRed", value) }
    func setGreen<T>(_ value: T) { store("setGreen", value) }
    func setBlue<T>(_ value: T) { store("setBlue", value) }
    func setDrum<T>(_ value: T) { store("setDrum", value) }
    func setEyeEnum<T>(_ value: T) { store("setEyeEnum", value) }
    func setLedStatusEnum<T>(_ value: T) { store("setLedStatusEnum", value) }
    func setHertz<T>(_ value: T) { store("setHertz", value) }
    func setSelectedTone<T>(_ value: T) { store("setSelectedTone", value) }
    func setLength<T>(_ value: T) { store("setLength", value) }
    func setMidiValue<T>(_ value: T) { store("setMidiValue", value) }
    func setPenSize<T>(_ value: T) { store("setPenSize", value) }
    func setPhysicsLook<T>(_ value: T) { store("setPhysicsLook", value) }
    func setPinNumberFormula<T>(_ value: T) { store("setPinNumberFormula", value) }
    func setPinValue<T>(_ value: T) { store("setPinValue", value) }
    func setPwmFrequencyFormula<T>(_ value: T) { store("setPwmFrequencyFormula", value) }
    func setPwmPercentageFormula<T>(_ value: T) { store("setPwmPercentageFormula", value) }
    func setPointedSprite<T>(_ value: T) { store("setPointedSprite", value) }
    func setRange<T>(_ value: T) { store("setRange", value) }
    func setRotationStyle<T>(_ value: T) { store("setRotationStyle", value) }
    func setSize<T>(_ value: T) { store("setSize", value) }
    func setSoundFilePath<T>(_ value: T) { store("setSoundFilePath", value) }
    func setSpeed<T>(_ value: T) { store("setSpeed", value) }
    func setType<T>(_ value: T) { store("setType", value) }
    func setVariableToHide<T>(_ value: T) { store("setVariableToHide", value) }
    func setVariableToShow<T>(_ value: T) { store("setVariableToShow", value) }
    func setVolume<T>(_ value: T) { store("setVolume", value) }
    func setVolumeInPercent<T>(_ value: T) { store("setVolumeInPercent", value) }
    func setWidth<T>(_ value: T) { store("setWidth", value) }
    func setX<T>(_ value: T) { store("setX", value) }
    func setY<T>(_ value: T) { store("setY", value) }
    func setDegreesInUserInterfaceDimensionUnit<T>(_ value: T) { store("setDegreesInUserInterfaceDimensionUnit", value) }
    func setCondition<T>(_ value: T) { store("setCondition", value) }
    func setControlVariable<T>(_ value: T) { store("setControlVariable", value) }
    func setCurrentItemVariable<T>(_ value: T) { store("setCurrentItemVariable", value) }
    func setForeverRepeat<T>(_ value: T) { store("setForeverRepeat", value) }
    func setInstrument<T>(_ value: T) { store("setInstrument", value) }
    func setBackCamera<T>(_ value: T) { store("setBackCamera", value) }
}

public extension IOSMissingEventActionAdapter {
    func setDurationInSeconds<T>(_ value: T) { store("setDurationInSeconds", value) }
    func setRelativeTextSize<T>(_ value: T) { store("setRelativeTextSize", value) }
    func setAlignment<T>(_ value: T) { store("setAlignment", value) }
    func setText<T>(_ value: T) { store("setText", value) }
    func setRed<T>(_ value: T) { store("setRed", value) }
    func setGreen<T>(_ value: T) { store("setGreen", value) }
    func setBlue<T>(_ value: T) { store("setBlue", value) }
    func setDrum<T>(_ value: T) { store("setDrum", value) }
    func setEyeEnum<T>(_ value: T) { store("setEyeEnum", value) }
    func setLedStatusEnum<T>(_ value: T) { store("setLedStatusEnum", value) }
    func setHertz<T>(_ value: T) { store("setHertz", value) }
    func setSelectedTone<T>(_ value: T) { store("setSelectedTone", value) }
    func setLength<T>(_ value: T) { store("setLength", value) }
    func setMidiValue<T>(_ value: T) { store("setMidiValue", value) }
    func setPenSize<T>(_ value: T) { store("setPenSize", value) }
    func setPhysicsLook<T>(_ value: T) { store("setPhysicsLook", value) }
    func setPinNumberFormula<T>(_ value: T) { store("setPinNumberFormula", value) }
    func setPinValue<T>(_ value: T) { store("setPinValue", value) }
    func setPwmFrequencyFormula<T>(_ value: T) { store("setPwmFrequencyFormula", value) }
    func setPwmPercentageFormula<T>(_ value: T) { store("setPwmPercentageFormula", value) }
    func setPointedSprite<T>(_ value: T) { store("setPointedSprite", value) }
    func setRange<T>(_ value: T) { store("setRange", value) }
    func setRotationStyle<T>(_ value: T) { store("setRotationStyle", value) }
    func setSize<T>(_ value: T) { store("setSize", value) }
    func setSoundFilePath<T>(_ value: T) { store("setSoundFilePath", value) }
    func setSpeed<T>(_ value: T) { store("setSpeed", value) }
    func setType<T>(_ value: T) { store("setType", value) }
    func setVariableToHide<T>(_ value: T) { store("setVariableToHide", value) }
    func setVariableToShow<T>(_ value: T) { store("setVariableToShow", value) }
    func setVolume<T>(_ value: T) { store("setVolume", value) }
    func setVolumeInPercent<T>(_ value: T) { store("setVolumeInPercent", value) }
    func setWidth<T>(_ value: T) { store("setWidth", value) }
    func setX<T>(_ value: T) { store("setX", value) }
    func setY<T>(_ value: T) { store("setY", value) }
    func setDegreesInUserInterfaceDimensionUnit<T>(_ value: T) { store("setDegreesInUserInterfaceDimensionUnit", value) }
    func setCondition<T>(_ value: T) { store("setCondition", value) }
    func setControlVariable<T>(_ value: T) { store("setControlVariable", value) }
    func setCurrentItemVariable<T>(_ value: T) { store("setCurrentItemVariable", value) }
    func setForeverRepeat<T>(_ value: T) { store("setForeverRepeat", value) }
    func setInstrument<T>(_ value: T) { store("setInstrument", value) }
    func setBackCamera<T>(_ value: T) { store("setBackCamera", value) }
}

public extension IOSMissingLoopActionAdapter {
    func setDurationInSeconds<T>(_ value: T) { store("setDurationInSeconds", value) }
    func setRelativeTextSize<T>(_ value: T) { store("setRelativeTextSize", value) }
    func setAlignment<T>(_ value: T) { store("setAlignment", value) }
    func setText<T>(_ value: T) { store("setText", value) }
    func setRed<T>(_ value: T) { store("setRed", value) }
    func setGreen<T>(_ value: T) { store("setGreen", value) }
    func setBlue<T>(_ value: T) { store("setBlue", value) }
    func setDrum<T>(_ value: T) { store("setDrum", value) }
    func setEyeEnum<T>(_ value: T) { store("setEyeEnum", value) }
    func setLedStatusEnum<T>(_ value: T) { store("setLedStatusEnum", value) }
    func setHertz<T>(_ value: T) { store("setHertz", value) }
    func setSelectedTone<T>(_ value: T) { store("setSelectedTone", value) }
    func setLength<T>(_ value: T) { store("setLength", value) }
    func setMidiValue<T>(_ value: T) { store("setMidiValue", value) }
    func setPenSize<T>(_ value: T) { store("setPenSize", value) }
    func setPhysicsLook<T>(_ value: T) { store("setPhysicsLook", value) }
    func setPinNumberFormula<T>(_ value: T) { store("setPinNumberFormula", value) }
    func setPinValue<T>(_ value: T) { store("setPinValue", value) }
    func setPwmFrequencyFormula<T>(_ value: T) { store("setPwmFrequencyFormula", value) }
    func setPwmPercentageFormula<T>(_ value: T) { store("setPwmPercentageFormula", value) }
    func setPointedSprite<T>(_ value: T) { store("setPointedSprite", value) }
    func setRange<T>(_ value: T) { store("setRange", value) }
    func setRotationStyle<T>(_ value: T) { store("setRotationStyle", value) }
    func setSize<T>(_ value: T) { store("setSize", value) }
    func setSoundFilePath<T>(_ value: T) { store("setSoundFilePath", value) }
    func setSpeed<T>(_ value: T) { store("setSpeed", value) }
    func setType<T>(_ value: T) { store("setType", value) }
    func setVariableToHide<T>(_ value: T) { store("setVariableToHide", value) }
    func setVariableToShow<T>(_ value: T) { store("setVariableToShow", value) }
    func setVolume<T>(_ value: T) { store("setVolume", value) }
    func setVolumeInPercent<T>(_ value: T) { store("setVolumeInPercent", value) }
    func setWidth<T>(_ value: T) { store("setWidth", value) }
    func setX<T>(_ value: T) { store("setX", value) }
    func setY<T>(_ value: T) { store("setY", value) }
    func setDegreesInUserInterfaceDimensionUnit<T>(_ value: T) { store("setDegreesInUserInterfaceDimensionUnit", value) }
    func setCondition<T>(_ value: T) { store("setCondition", value) }
    func setControlVariable<T>(_ value: T) { store("setControlVariable", value) }
    func setCurrentItemVariable<T>(_ value: T) { store("setCurrentItemVariable", value) }
    func setForeverRepeat<T>(_ value: T) { store("setForeverRepeat", value) }
    func setInstrument<T>(_ value: T) { store("setInstrument", value) }
    func setBackCamera<T>(_ value: T) { store("setBackCamera", value) }
}

public extension IOSMissingActionAdapter {
    func setInterpolation(_ interpolation: Interpolation?) { store("setInterpolation", interpolation as Any) }
}
public extension IOSMissingEventActionAdapter {
    func setInterpolation(_ interpolation: Interpolation?) { store("setInterpolation", interpolation as Any) }
}
public extension IOSMissingLoopActionAdapter {
    func setInterpolation(_ interpolation: Interpolation?) { store("setInterpolation", interpolation as Any) }
}


/// iOS implementation of the shared speech output service used by Speak bricks.
private final class IOSSpeechService: NSObject, AVSpeechSynthesizerDelegate {
    static let shared = IOSSpeechService()
    private let synthesizer = AVSpeechSynthesizer()
    private var utteranceIDs: [ObjectIdentifier: UUID] = [:]
    private var finishedIDs = Set<UUID>()
    private override init() { super.init(); synthesizer.delegate = self }
    @discardableResult func speak(_ text: String, language: String?) -> UUID {
        let id = UUID()
        DispatchQueue.main.async {
            let utterance = AVSpeechUtterance(string: text)
            if let language = language, !language.isEmpty { utterance.voice = AVSpeechSynthesisVoice(language: language) }
            self.utteranceIDs[ObjectIdentifier(utterance)] = id
            self.synthesizer.speak(utterance)
            if text.isEmpty { self.finishedIDs.insert(id) }
        }
        return id
    }
    func isFinished(_ id: UUID) -> Bool { finishedIDs.contains(id) }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if let id = utteranceIDs.removeValue(forKey: ObjectIdentifier(utterance)) { finishedIDs.insert(id) }
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        if let id = utteranceIDs.removeValue(forKey: ObjectIdentifier(utterance)) { finishedIDs.insert(id) }
    }
}

private enum IOSURLTools {
    static func url(from value: String) -> URL? {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        if let url = URL(string: trimmed), url.scheme != nil { return url }
        return URL(string: "https://" + trimmed)
    }
}


private enum IOSFileTools {
    static func safeFileName(_ input: String) -> String {
        let invalid = CharacterSet(charactersIn: "/\\:").union(.controlCharacters).union(.newlines)
        let cleaned = input.components(separatedBy: invalid).filter { !$0.isEmpty }.joined(separator: "_")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return cleaned.isEmpty ? "variable" : cleaned
    }
    static func exportDirectory() -> URL {
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        return base.appendingPathComponent("CatroidExports", isDirectory: true)
    }
}


private enum IOSPlotExport {
    static func writeSVG(points: [[CGPoint]], name: String) -> URL? {
        let all = points.flatMap { $0 }
        guard !all.isEmpty else { return nil }
        let minX = all.map(\.x).min() ?? 0, maxX = all.map(\.x).max() ?? 1
        let minY = all.map(\.y).min() ?? 0, maxY = all.map(\.y).max() ?? 1
        let width = max(1, maxX - minX), height = max(1, maxY - minY)
        var body = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(width)\" height=\"\(height)\" viewBox=\"\(minX) \(-maxY) \(width) \(height)\">"
        for line in points where line.count > 1 {
            let coordinates = line.map { "\($0.x),\(-$0.y)" }.joined(separator: " ")
            body += "<polyline fill=\"none\" stroke=\"black\" stroke-width=\"1\" points=\"\(coordinates)\"/>"
        }
        body += "</svg>"
        let filename = IOSFileTools.safeFileName(name)
        let url = IOSFileTools.exportDirectory().appendingPathComponent(filename.hasSuffix(".svg") ? filename : filename + ".svg")
        do {
            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            try body.write(to: url, atomically: true, encoding: .utf8)
            return url
        } catch { return nil }
    }
}

private enum IOSActionAlerts {
    static func show(title: String, message: String) {
        DispatchQueue.main.async {
            guard let controller = StageViewController.activeStage else { return }
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            controller.present(alert, animated: true)
        }
    }
    static func share(_ url: URL) {
        DispatchQueue.main.async {
            guard let controller = StageViewController.activeStage else { return }
            let sheet = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            if let popover = sheet.popoverPresentationController { popover.sourceView = controller.view; popover.sourceRect = CGRect(x: controller.view.bounds.midX, y: controller.view.bounds.midY, width: 0, height: 0) }
            controller.present(sheet, animated: true)
        }
    }
}


public enum IOSCameraPreferences {
    public static var useFrontCamera = false
}

private enum IOSColorTools {
    static func color(from input: String) -> UIColor {
        let cleaned = input.trimmingCharacters(in: CharacterSet(charactersIn: "# "))
        guard cleaned.count == 6, let value = UInt32(cleaned, radix: 16) else { return .white }
        return UIColor(red: CGFloat((value >> 16) & 0xff) / 255,
                       green: CGFloat((value >> 8) & 0xff) / 255,
                       blue: CGFloat(value & 0xff) / 255, alpha: 1)
    }
}

public enum IOSSpeechPreferences { public static var languageTag = Locale.current.identifier }
