import Foundation

open class ActionFactory {

    public init() {}

    open func createUserBrickAction(_ sprite: Sprite, _ sequence: SequenceAction, _ userDefinedBrickInputs: [UserDefinedBrickInput], _ userDefinedBrickID: UUID) -> EventAction {
        let action = UserDefinedBrickAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setInputs(userDefinedBrickInputs)
        action.setUserDefinedBrickID(userDefinedBrickID)
        action.setSprite(sprite)
        action.setWait(true)
        return action
    }

    open func createBroadcastAction(_ broadcastMessage: String, _ wait: Bool) -> EventAction {
        let action = BroadcastAction()
        action.setBroadcastMessage(broadcastMessage)
        action.setWait(wait)
        return action
    }

    open func createWaitAction(_ sprite: Sprite, _ sequence: SequenceAction, _ delay: Formula) -> Action {
        let action = WaitAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDelay(delay)
        return action
    }

    open func createWaitForSoundAction(_ sprite: Sprite, _ sequence: SequenceAction, _ delay: Formula, _ soundFilePath: String) -> Action {
        let action = WaitForSoundAction()
        action.setSoundFilePath(soundFilePath)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDelay(delay)
        return action
    }

    open func createPlaySoundAtAction(_ sprite: Sprite, _ sequence: SequenceAction, _ delay: Formula, _ sound: SoundInfo) -> Action {
        let action = PlaySoundAtAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setSprite(sprite)
        action.setSound(sound)
        action.setScope(scope)
        action.setOffset(delay)
        return action
    }

    open func createWaitForBubbleBrickAction(_ sprite: Sprite, _ sequence: SequenceAction, _ delay: Formula) -> Action {
        let action = WaitForBubbleBrickAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDelay(delay)
        return action
    }

    open func createChangeBrightnessByNAction(_ sprite: Sprite, _ sequence: SequenceAction, _ changeBrightness: Formula) -> Action {
        let action = ChangeBrightnessByNAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setBrightness(changeBrightness)
        return action
    }

    open func createChangeColorByNAction(_ sprite: Sprite, _ sequence: SequenceAction, _ changeColor: Formula) -> Action {
        let action = ChangeColorByNAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setColor(changeColor)
        return action
    }

    open func createChangeTransparencyByNAction(_ sprite: Sprite, _ sequence: SequenceAction, _ transparency: Formula) -> Action {
        let action = ChangeTransparencyByNAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setTransparency(transparency)
        return action
    }

    open func createChangeSizeByNAction(_ sprite: Sprite, _ sequence: SequenceAction, _ size: Formula) -> Action {
        let action = ChangeSizeByNAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSize(size)
        return action
    }

    open func createChangeVolumeByNAction(_ sprite: Sprite, _ sequence: SequenceAction, _ volume: Formula) -> Action {
        let action = ChangeVolumeByNAction()
        action.setVolume(volume)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        return action
    }

    open func createChangeXByNAction(_ sprite: Sprite, _ sequence: SequenceAction, _ xMovement: Formula) -> Action {
        let action = ChangeXByNAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setxMovement(xMovement)
        return action
    }

    open func createChangeYByNAction(_ sprite: Sprite, _ sequence: SequenceAction, _ yMovement: Formula) -> Action {
        let action = ChangeYByNAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setyMovement(yMovement)
        return action
    }

    open func createSetRotationStyleAction(_ sprite: Sprite, _ mode: Int) -> Action {
        let action = SetRotationStyleAction()
        action.setRotationStyle(mode)
        action.setSprite(sprite)
        return action
    }

    open func createClearGraphicEffectAction(_ sprite: Sprite) -> Action {
        let action = ClearGraphicEffectAction()
        action.setSprite(sprite)
        return action
    }

    open func createComeToFrontAction(_ sprite: Sprite) -> Action {
        let action = ComeToFrontAction()
        action.setSprite(sprite)
        return action
    }

    open func createGlideToAction(_ sprite: Sprite, _ sequence: SequenceAction, _ x: Formula, _ y: Formula, _ duration: Formula) -> Action {
        let action = GlideToAction()
        action.setPosition(x, y)
        action.setDuration(duration)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        return action
    }

    open func createPlaceAtAction(_ sprite: Sprite, _ sequence: SequenceAction, _ x: Formula, _ y: Formula) -> Action {
        let action = GlideToAction()
        action.setPosition(x, y)
        action.setDuration(0)
        action.setInterpolation(nil)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        return action
    }

    open func createGoToAction(_ sprite: Sprite, _ destinationSprite: Sprite, _ spinnerSelection: Int) -> Action? {
        switch spinnerSelection {
        case BrickValues.goToTouchPosition:
            let touchPositionAction = GoToTouchPositionAction()
            touchPositionAction.setSprite(sprite)
            return touchPositionAction
        case BrickValues.goToRandomPosition:
            let randomPositionAction = GoToRandomPositionAction()
            randomPositionAction.setSprite(sprite)
            return randomPositionAction
        case BrickValues.goToOtherSpritePosition:
            let otherSpritePositionAction = GoToOtherSpritePositionAction()
            otherSpritePositionAction.setSprite(sprite)
            otherSpritePositionAction.setDestinationSprite(destinationSprite)
            return otherSpritePositionAction
        default:
            return nil
        }
    }

    open func createGoNStepsBackAction(_ sprite: Sprite, _ sequence: SequenceAction, _ steps: Formula) -> Action {
        let action = GoNStepsBackAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSteps(steps)
        return action
    }

    open func createHideAction(_ sprite: Sprite) -> Action {
        let action = SetVisibleAction()
        action.setSprite(sprite)
        action.setVisible(false)
        return action
    }

    open func createIfOnEdgeBounceAction(_ sprite: Sprite) -> Action {
        let action = IfOnEdgeBounceAction()
        action.setSprite(sprite)
        return action
    }

    open func createLegoNxtMotorMoveAction(_ sprite: Sprite, _ sequence: SequenceAction, _ motorEnum: LegoNxtMotorMoveBrick.Motor, _ speed: Formula) -> Action {
        let action = LegoNxtMotorMoveAction()
        action.setMotorEnum(motorEnum)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSpeed(speed)
        return action
    }

    open func createLegoNxtMotorStopAction(_ motorEnum: LegoNxtMotorStopBrick.Motor) -> Action {
        let action = LegoNxtMotorStopAction()
        action.setMotorEnum(motorEnum)
        return action
    }

    open func createLegoNxtMotorTurnAngleAction(_ sprite: Sprite, _ sequence: SequenceAction, _ motorEnum: LegoNxtMotorTurnAngleBrick.Motor, _ degrees: Formula) -> Action {
        let action = LegoNxtMotorTurnAngleAction()
        action.setMotorEnum(motorEnum)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDegrees(degrees)
        return action
    }

    open func createLegoNxtPlayToneAction(_ sprite: Sprite, _ sequence: SequenceAction, _ hertz: Formula, _ durationInSeconds: Formula) -> Action {
        let action = LegoNxtPlayToneAction()
        action.setHertz(hertz)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDurationInSeconds(durationInSeconds)
        return action
    }

    open func createLegoEv3SingleMotorMoveAction(_ sprite: Sprite, _ sequence: SequenceAction, _ motorEnum: LegoEv3MotorMoveBrick.Motor, _ speed: Formula) -> Action {
        let action = LegoEv3MotorMoveAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setMotorEnum(motorEnum)
        action.setSpeed(speed)
        return action
    }

    open func createLegoEv3MotorStopAction(_ motorEnum: LegoEv3MotorStopBrick.Motor) -> Action {
        let action = LegoEv3MotorStopAction()
        action.setMotorEnum(motorEnum)
        return action
    }

    open func createLegoEv3SetLedAction(_ ledStatusEnum: LegoEv3SetLedBrick.LedStatus) -> Action {
        let action = LegoEv3SetLedAction()
        action.setLedStatusEnum(ledStatusEnum)
        return action
    }

    open func createLegoEv3PlayToneAction(_ sprite: Sprite, _ sequence: SequenceAction, _ hertz: Formula, _ durationInSeconds: Formula, _ volumeInPercent: Formula) -> Action {
        let action = LegoEv3PlayToneAction()
        action.setHertz(hertz)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDurationInSeconds(durationInSeconds)
        action.setVolumeInPercent(volumeInPercent)
        return action
    }

    open func createLegoEv3MotorTurnAngleAction(_ sprite: Sprite, _ sequence: SequenceAction, _ motorEnum: LegoEv3MotorTurnAngleBrick.Motor, _ degrees: Formula) -> Action {
        let action = LegoEv3MotorTurnAngleAction()
        action.setMotorEnum(motorEnum)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDegrees(degrees)
        return action
    }

    open func createPhiroPlayToneActionAction(_ sprite: Sprite, _ sequence: SequenceAction, _ toneEnum: PhiroPlayToneBrick.Tone, _ duration: Formula) -> Action {
        let action = PhiroPlayToneAction()
        action.setSelectedTone(toneEnum)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDurationInSeconds(duration)
        return action
    }

    open func createPhiroMotorMoveForwardActionAction(_ sprite: Sprite, _ sequence: SequenceAction, _ motorEnum: PhiroMotorMoveForwardBrick.Motor, _ speed: Formula) -> Action {
        let action = PhiroMotorMoveForwardAction()
        action.setMotorEnum(motorEnum)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSpeed(speed)
        return action
    }

    open func createPhiroMotorMoveBackwardActionAction(_ sprite: Sprite, _ sequence: SequenceAction, _ motorEnum: PhiroMotorMoveBackwardBrick.Motor, _ speed: Formula) -> Action {
        let action = PhiroMotorMoveBackwardAction()
        action.setMotorEnum(motorEnum)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSpeed(speed)
        return action
    }

    open func createPhiroRgbLedEyeActionAction(_ sprite: Sprite, _ sequence: SequenceAction, _ eye: PhiroRGBLightBrick.Eye, _ red: Formula, _ green: Formula, _ blue: Formula) -> Action {
        let action = PhiroRGBLightAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setEyeEnum(eye)
        action.setRed(red)
        action.setGreen(green)
        action.setBlue(blue)
        return action
    }

    open func createPhiroSendSelectedSensorAction(_ sprite: Sprite, _ sequence: SequenceAction, _ sensorNumber: Int, _ ifAction: Action, _ elseAction: Action?) -> Action {
        let action = PhiroSensorAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSensor(sensorNumber)
        action.setIfAction(ifAction)
        action.setElseAction(elseAction)
        return action
    }

    open func createPhiroMotorStopActionAction(_ motorEnum: PhiroMotorStopBrick.Motor) -> Action {
        let action = PhiroMotorStopAction()
        action.setMotorEnum(motorEnum)
        return action
    }

    open func createMoveNStepsAction(_ sprite: Sprite, _ sequence: SequenceAction, _ steps: Formula) -> Action {
        let action = MoveNStepsAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSteps(steps)
        return action
    }

    open func createPenDownAction(_ sprite: Sprite) -> Action {
        let action = PenDownAction()
        action.setSprite(sprite)
        return action
    }

    open func createPenUpAction(_ sprite: Sprite) -> Action {
        let action = PenUpAction()
        action.setSprite(sprite)
        return action
    }

    open func createStartPlotAction(_ sprite: Sprite) -> Action {
        let action = StartPlotAction()
        action.setSprite(sprite)
        return action
    }

    open func createStopPlotAction(_ sprite: Sprite) -> Action {
        let action = StopPlotAction()
        action.setSprite(sprite)
        return action
    }

    open func createStartEngraveAction(_ sprite: Sprite) -> Action {
        let action = StartEngraveAction()
        action.setSprite(sprite)
        return action
    }

    open func createStopEngraveAction(_ sprite: Sprite) -> Action {
        let action = StopEngraveAction()
        action.setSprite(sprite)
        return action
    }

    open func createStartCutAction(_ sprite: Sprite) -> Action {
        let action = StartCutAction()
        action.setSprite(sprite)
        return action
    }

    open func createStopCutAction(_ sprite: Sprite) -> Action {
        let action = StopCutAction()
        action.setSprite(sprite)
        return action
    }

    open func createArcAction(_ sprite: Sprite, _ sequence: SequenceAction, _ direction: ArcBrick.Directions, _ radius: Formula, _ degrees: Formula) -> Action {
        let action = ArcAction()
        action.setScope(Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence))
        action.setDirection(direction)
        action.setRadius(radius)
        action.setDegrees(degrees)
        action.setDuration(0)
        action.setInterpolation(nil)
        return action
    }

    open func createGoThroughAction(_ sprite: Sprite, _ sequence: SequenceAction, _ x1: Formula, _ y1: Formula, _ x2: Formula, _ y2: Formula) -> Action {
        let action = GoThroughAction()
        action.setScope(Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence))
        action.setTargetCoordinates(x1, y1, x2, y2)
        action.setDuration(0)
        action.setInterpolation(nil)
        return action
    }

    open func createSetPenSizeAction(_ sprite: Sprite, _ sequence: SequenceAction, _ penSize: Formula) -> Action {
        let action = SetPenSizeAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPenSize(penSize)
        return action
    }

    open func createSetPenColorAction(_ sprite: Sprite, _ sequence: SequenceAction, _ red: Formula, _ green: Formula, _ blue: Formula) -> Action {
        let action = SetPenColorAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setRed(red)
        action.setGreen(green)
        action.setBlue(blue)
        return action
    }

    open func createClearBackgroundAction() -> Action {
        return ClearBackgroundAction()
    }

    open func createSetCameraFocusPointAction(_ sprite: Sprite, _ sequence: SequenceAction, _ horizontal: Formula, _ vertical: Formula) -> Action {
        let action = SetCameraFocusPointAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSprite(sprite)
        action.setHorizontal(horizontal)
        action.setVertical(vertical)
        return action
    }

    open func createStampAction(_ sprite: Sprite) -> Action {
        let action = StampAction()
        action.setSprite(sprite)
        return action
    }

    open func createPlaySoundAction(_ sprite: Sprite, _ sound: SoundInfo) -> Action {
        let action = PlaySoundAction()
        action.setSprite(sprite)
        action.setSound(sound)
        return action
    }

    open func createStopSoundAction(_ sprite: Sprite, _ sound: SoundInfo) -> Action {
        let action = StopSoundAction()
        action.setSprite(sprite)
        action.setSound(sound)
        return action
    }

    open func createPointInDirectionAction(_ sprite: Sprite, _ sequence: SequenceAction, _ degrees: Formula) -> Action {
        let action = PointInDirectionAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDegreesInUserInterfaceDimensionUnit(degrees)
        return action
    }

    open func createPointToAction(_ sprite: Sprite, _ pointedSprite: Sprite) -> Action {
        let action = PointToAction()
        action.setSprite(sprite)
        action.setPointedSprite(pointedSprite)
        return action
    }

    open func createCloneAction(_ sprite: Sprite) -> Action {
        let action = CloneAction()
        action.setSprite(sprite)
        return action
    }

    open func createDeleteThisCloneAction(_ sprite: Sprite) -> Action {
        let action = DeleteThisCloneAction()
        action.setSprite(sprite)
        return action
    }

    open func createSetBrightnessAction(_ sprite: Sprite, _ sequence: SequenceAction, _ brightness: Formula) -> Action {
        let action = SetBrightnessAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setBrightness(brightness)
        return action
    }

    open func createSetColorAction(_ sprite: Sprite, _ sequence: SequenceAction, _ color: Formula) -> Action {
        let action = SetColorAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setColor(color)
        return action
    }

    open func createSetTransparencyAction(_ sprite: Sprite, _ sequence: SequenceAction, _ transparency: Formula) -> Action {
        let action = SetTransparencyAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setTransparency(transparency)
        return action
    }

    open func createSetLookAction(_ sprite: Sprite, _ lookData: LookData) -> Action {
        return createSetLookAction(sprite, lookData, false)
    }

    open func createSetLookAction(_ sprite: Sprite, _ lookData: LookData, _ wait: Bool) -> Action {
        let action = SetLookAction()
        action.setSprite(sprite)
        action.setLookData(lookData)
        action.setWait(wait)
        return action
    }

    open func createSetLookByIndexAction(_ sprite: Sprite, _ sequence: SequenceAction, _ formula: Formula) -> Action {
        let action = SetLookByIndexAction()
        action.setSprite(sprite)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(formula)
        return action
    }

    open func createSetBackgroundAction(_ lookData: LookData, _ wait: Bool) -> Action {
        let action = SetLookAction()
        action.setSprite(ProjectManager.shared.currentlyPlayingScene.backgroundSprite)
        action.setLookData(lookData)
        action.setWait(wait)
        return action
    }

    open func createSetBackgroundByIndexAction(_ sprite: Sprite, _ sequence: SequenceAction, _ formula: Formula, _ wait: Bool) -> Action {
        let action = SetLookByIndexAction()
        action.setSprite(ProjectManager.shared.currentlyPlayingScene.backgroundSprite)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(formula)
        action.setWait(wait)
        return action
    }

    open func createSetNextLookAction(_ sprite: Sprite, _ sequence: SequenceAction) -> Action {
        let action = SetNextLookAction()
        action.setSprite(sprite)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        return action
    }

    open func createSetPreviousLookAction(_ sprite: Sprite, _ sequence: SequenceAction) -> Action {
        let action = SetPreviousLookAction()
        action.setSprite(sprite)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        return action
    }

    open func createDeleteLookAction(_ sprite: Sprite) -> Action {
        let action = DeleteLookAction()
        action.setSprite(sprite)
        return action
    }

    open func createSetSizeToAction(_ sprite: Sprite, _ sequence: SequenceAction, _ size: Formula) -> Action {
        let action = SetSizeToAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSize(size)
        return action
    }

    open func createGlideToPhysicsAction(_ sprite: Sprite, _ physicsLook: PhysicsLook, _ sequence: SequenceAction, _ x: Formula, _ y: Formula, _ duration: Float, _ delta: Float) -> Action {
        let action = GlideToPhysicsAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPhysicsLook(physicsLook)
        action.setPosition(x, y)
        action.setDuration(duration)
        action.act(delta)
        return action
    }

    open func createSetVolumeToAction(_ sprite: Sprite, _ sequence: SequenceAction, _ volume: Formula) -> Action {
        let action = SetVolumeToAction()
        action.setVolume(volume)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        return action
    }

    open func createSetXAction(_ sprite: Sprite, _ sequence: SequenceAction, _ x: Formula) -> Action {
        let action = SetXAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setX(x)
        return action
    }

    open func createSetYAction(_ sprite: Sprite, _ sequence: SequenceAction, _ y: Formula) -> Action {
        let action = SetYAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setY(y)
        return action
    }

    open func createShowAction(_ sprite: Sprite) -> Action {
        let action = SetVisibleAction()
        action.setSprite(sprite)
        action.setVisible(true)
        return action
    }

    open func createSpeakAction(_ sprite: Sprite, _ sequence: SequenceAction, _ text: Formula) -> Action {
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        let action = SpeakAction(scope: scope, text: text)
        return action
    }

    open func createSpeakAndWaitAction(_ sprite: Sprite, _ sequence: SequenceAction, _ text: Formula) -> Action {
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        let action = SpeakAndWaitAction(scope: scope, text: text)
        return action
    }

    open func createStopAllSoundsAction() -> Action {
        return StopAllSoundsAction()
    }

    open func createPauseForBeatsAction(_ sprite: Sprite, _ sequence: SequenceAction, _ beats: Formula) -> Action {
        let action = PauseForBeatsAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setBeats(beats)
        return action
    }

    open func createPlayNoteForBeatsAction(_ sprite: Sprite, _ sequence: SequenceAction, _ note: Formula, _ beats: Formula) -> Action {
        let action = PlayNoteForBeatsAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setMidiValue(note)
        action.setBeats(beats)
        return action
    }

    open func createSetInstrumentAction(_ instrument: PickableMusicalInstrument) -> Action {
        let action = SetInstrumentAction()
        action.setInstrument(instrument)
        return action
    }

    open func createSetTempoAction(_ sprite: Sprite, _ sequence: SequenceAction, _ tempo: Formula) -> Action {
        let action = SetTempoAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setTempo(tempo)
        return action
    }

    open func createChangeTempoAction(_ sprite: Sprite, _ sequence: SequenceAction, _ tempo: Formula) -> Action {
        let action = ChangeTempoByAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setTempo(tempo)
        return action
    }

    open func createPlayDrumForBeatsAction(_ sprite: Sprite, _ sequence: SequenceAction, _ beats: Formula, _ drum: PickableDrum) -> Action {
        let action = PlayDrumForBeatsAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setBeats(beats)
        action.setDrum(drum)
        return action
    }

    open func createTurnLeftAction(_ sprite: Sprite, _ sequence: SequenceAction, _ degrees: Formula) -> Action {
        let action = TurnLeftAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDegrees(degrees)
        return action
    }

    open func createTurnRightAction(_ sprite: Sprite, _ sequence: SequenceAction, _ degrees: Formula) -> Action {
        let action = TurnRightAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDegrees(degrees)
        return action
    }

    open func createChangeVariableAction(_ sprite: Sprite, _ sequence: SequenceAction, _ variableFormula: Formula, _ userVariable: UserVariable) -> Action {
        let action = ChangeVariableAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setChangeVariable(variableFormula)
        action.setUserVariable(userVariable)
        return action
    }

    open func createSetVariableAction(_ sprite: Sprite, _ sequence: SequenceAction, _ variableFormula: Formula, _ userVariable: UserVariable) -> Action {
        let action = SetVariableAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setChangeVariable(variableFormula)
        action.setUserVariable(userVariable)
        return action
    }

    open func createAskAction(_ sprite: Sprite, _ sequence: SequenceAction, _ questionFormula: Formula, _ answerVariable: UserVariable) -> Action {
        let action = AskAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setQuestionFormula(questionFormula)
        action.setAnswerVariable(answerVariable)
        return action
    }

    open func createAskSpeechAction(_ sprite: Sprite, _ sequence: SequenceAction, _ questionFormula: Formula, _ answerVariable: UserVariable) -> Action {
        let action = AskSpeechAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setQuestionFormula(questionFormula)
        action.setAnswerVariable(answerVariable)
        return action
    }

    open func createDeleteItemOfUserListAction(_ sprite: Sprite, _ sequence: SequenceAction, _ userListFormula: Formula, _ userList: UserList) -> Action {
        let action = DeleteItemOfUserListAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormulaIndexToDelete(userListFormula)
        action.setUserList(userList)
        return action
    }

    open func createClearUserListAction(_ userList: UserList) -> Action {
        let action = ClearUserListAction()
        action.setUserList(userList)
        return action
    }

    open func createAddItemToUserListAction(_ sprite: Sprite, _ sequence: SequenceAction, _ userListFormula: Formula, _ userList: UserList) -> Action {
        let action = AddItemToUserListAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormulaItemToAdd(userListFormula)
        action.setUserList(userList)
        return action
    }

    open func createInsertItemIntoUserListAction(_ sprite: Sprite, _ sequence: SequenceAction, _ userListFormulaIndexToInsert: Formula, _ userListFormulaItemToInsert: Formula, _ userList: UserList) -> Action {
        let action = InsertItemIntoUserListAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormulaIndexToInsert(userListFormulaIndexToInsert)
        action.setFormulaItemToInsert(userListFormulaItemToInsert)
        action.setUserList(userList)
        return action
    }

    open func createStoreCSVIntoUserListAction(_ sprite: Sprite, _ sequence: SequenceAction, _ userListFormulaColumn: Formula, _ userListFormulaCSV: Formula, _ userList: UserList) -> Action {
        let action = StoreCSVIntoUserListAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormulaColumnToExtract(userListFormulaColumn)
        action.setFormulaCSVData(userListFormulaCSV)
        action.setUserList(userList)
        return action
    }

    open func createReplaceItemInUserListAction(_ sprite: Sprite, _ sequence: SequenceAction, _ userListFormulaIndexToReplace: Formula, _ userListFormulaItemToInsert: Formula, _ userList: UserList) -> Action {
        let action = ReplaceItemInUserListAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormulaIndexToReplace(userListFormulaIndexToReplace)
        action.setFormulaItemToInsert(userListFormulaItemToInsert)
        action.setUserList(userList)
        return action
    }

    open func createResetTimerAction() -> Action {
        return ResetTimerAction()
    }

    open func createThinkSayBubbleAction(_ sprite: Sprite, _ sequence: SequenceAction, _ androidStringProvider: AndroidStringProvider, _ text: Formula, _ type: Int) -> Action {
        let action = ThinkSayBubbleAction()
        action.setText(text)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setAndroidStringProvider(androidStringProvider)
        action.setType(type)
        return action
    }

    open func createThinkSayForBubbleAction(_ sprite: Sprite, _ sequence: SequenceAction, _ androidStringProvider: AndroidStringProvider, _ text: Formula, _ type: Int) -> Action {
        let action = ThinkSayBubbleAction()
        action.setText(text)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setAndroidStringProvider(androidStringProvider)
        action.setType(type)
        return action
    }

    open func createSceneTransitionAction(_ sceneName: String, _ sprite: Sprite) -> Action {
        let action = SceneTransitionAction()
        action.setScene(sceneName)
        action.setSprite(sprite)
        return action
    }

    open func createSceneStartAction(_ sceneName: String, _ sprite: Sprite) -> Action {
        let action = SceneStartAction()
        action.setScene(sceneName)
        action.setSprite(sprite)
        return action
    }

    open func createIfLogicAction(_ sprite: Sprite, _ sequence: SequenceAction, _ condition: Formula, _ ifAction: Action, _ elseAction: Action?) -> Action {
        let action = IfLogicAction()
        action.setIfAction(ifAction)
        action.setIfCondition(condition)
        action.setElseAction(elseAction)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        return action
    }

    open func createRepeatAction(_ sprite: Sprite, _ sequence: SequenceAction, _ count: Formula, _ repeatedAction: Action, _ isLoopDelay: Bool) -> Action {
        let action = RepeatAction()
        action.setRepeatCount(count)
        action.setAction(repeatedAction)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setLoopDelay(isLoopDelay)
        return action
    }

    open func createForVariableFromToAction(_ sprite: Sprite, _ sequence: SequenceAction, _ controlVariable: UserVariable, _ from: Formula, _ to: Formula, _ repeatedAction: Action, _ isLoopDelay: Bool) -> Action {
        let action = ForVariableFromToAction()
        action.setRange(from, to)
        action.setControlVariable(controlVariable)
        action.setAction(repeatedAction)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setLoopDelay(isLoopDelay)
        return action
    }

    open func createForItemInUserListAction(_ userList: UserList, _ userVariable: UserVariable, _ repeatedAction: Action, _ isLoopDelay: Bool) -> Action {
        let action = ForItemInUserListAction()
        action.setAction(repeatedAction)
        action.setUserList(userList)
        action.setCurrentItemVariable(userVariable)
        action.setLoopDelay(isLoopDelay)
        return action
    }

    open func createWaitUntilAction(_ sprite: Sprite, _ sequence: SequenceAction, _ condition: Formula) -> Action {
        let action = WaitUntilAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setCondition(condition)
        return action
    }

    open func createRepeatUntilAction(_ sprite: Sprite, _ sequence: SequenceAction, _ condition: Formula, _ repeatedAction: Action, _ isLoopDelay: Bool) -> Action {
        let action = RepeatUntilAction()
        action.setRepeatCondition(condition)
        action.setAction(repeatedAction)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setLoopDelay(isLoopDelay)
        return action
    }

    open func createDelayAction(_ sprite: Sprite, _ sequence: SequenceAction, _ delay: Formula) -> Action {
        let action = WaitAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDelay(delay)
        return action
    }

    open func createForeverAction(_ sprite: Sprite, _ sequence: SequenceAction, _ foreverSequence: ScriptSequenceAction, _ isLoopDelay: Bool) -> Action {
        let action = RepeatAction()
        action.setForeverRepeat(true)
        action.setAction(foreverSequence)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setLoopDelay(isLoopDelay)
        return action
    }

    public static func createStitchAction(_ sprite: Sprite) -> Action {
        let action = StitchAction()
        action.setSprite(sprite)
        return action
    }

    open func createRunningStitchAction(_ sprite: Sprite, _ sequence: SequenceAction, _ length: Formula) -> Action {
        let action = RunningStitchAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setLength(length)
        return action
    }

    open func createTripleStitchAction(_ sprite: Sprite, _ sequence: SequenceAction, _ steps: Formula) -> Action {
        let action = TripleStitchAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setSteps(steps)
        return action
    }

    open func createZigZagStitchAction(_ sprite: Sprite, _ sequence: SequenceAction, _ length: Formula, _ width: Formula) -> Action {
        let action = ZigZagStitchAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setLength(length)
        action.setWidth(width)
        return action
    }

    public static func createStopRunningStitchAction(_ sprite: Sprite) -> Action {
        let action = StopRunningStitchAction()
        action.setSprite(sprite)
        return action
    }

    open func createWriteEmbroideryToFileAction(_ sprite: Sprite, _ sequence: SequenceAction, _ fileName: Formula) -> Action {
        let action = WriteEmbroideryToFileAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(fileName)
        return action
    }

    open func createSavePlotAction(_ sprite: Sprite, _ sequence: SequenceAction, _ fileName: Formula) -> Action {
        let action = SavePlotAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(fileName)
        return action
    }

    open func createSaveLaserAction(_ sprite: Sprite, _ sequence: SequenceAction, _ fileName: Formula) -> Action {
        let action = SaveLaserAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(fileName)
        return action
    }

    open func createSharePlotAction(_ sprite: Sprite, _ sequence: SequenceAction, _ fileName: Formula) -> Action {
        let action = SharePlotAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(fileName)
        return action
    }

    open func createShareLaserAction(_ sprite: Sprite, _ sequence: SequenceAction, _ fileName: Formula) -> Action {
        let action = ShareLaserAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(fileName)
        return action
    }

    open func createSewUpAction(_ sprite: Sprite) -> Action {
        let action = SewUpAction()
        action.setSprite(sprite)
        return action
    }

    open func createSetThreadColorAction(_ sprite: Sprite, _ sequence: SequenceAction, _ color: Formula) -> Action {
        let action = SetThreadColorAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setSprite(sprite)
        action.setScope(scope)
        action.setColor(color)
        return action
    }

    public static func createScriptSequenceAction(_ script: Script) -> Action {
        return ScriptSequenceAction(script)
    }

    open func createSetBounceFactorAction(_ sprite: Sprite, _ sequence: SequenceAction, _ bounceFactor: Formula) -> Action {
        fatalError("throw new RuntimeException(\"No physics action available in non-physics sprite!\")")
    }

    open func createTurnRightSpeedAction(_ sprite: Sprite, _ sequence: SequenceAction, _ degreesPerSecond: Formula) -> Action {
        fatalError("throw new RuntimeException(\"No physics action available in non-physics sprite!\")")
    }

    open func createTurnLeftSpeedAction(_ sprite: Sprite, _ sequence: SequenceAction, _ degreesPerSecond: Formula) -> Action {
        fatalError("throw new RuntimeException(\"No physics action available in non-physics sprite!\")")
    }

    open func createSetVelocityAction(_ sprite: Sprite, _ sequence: SequenceAction, _ velocityX: Formula, _ velocityY: Formula) -> Action {
        fatalError("throw new RuntimeException(\"No physics action available in non-physics sprite!\")")
    }

    open func createSetPhysicsObjectTypeAction(_ sprite: Sprite, _ type: PhysicsObject.Type) -> Action {
        fatalError("throw new RuntimeException(\"No physics action available in non-physics sprite!\")")
    }

    open func createSetMassAction(_ sprite: Sprite, _ sequence: SequenceAction, _ mass: Formula) -> Action {
        fatalError("throw new RuntimeException(\"No physics action available in non-physics sprite!\")")
    }

    open func createSetGravityAction(_ sprite: Sprite, _ sequence: SequenceAction, _ gravityX: Formula, _ gravityY: Formula) -> Action {
        fatalError("throw new RuntimeException(\"No physics action available in non-physics sprite!\")")
    }

    open func createSetFrictionAction(_ sprite: Sprite, _ sequence: SequenceAction, _ friction: Formula) -> Action {
        fatalError("throw new RuntimeException(\"No physics action available in non-physics sprite!\")")
    }

    open func createSetTextAction(_ sprite: Sprite, _ sequence: SequenceAction, _ x: Formula, _ y: Formula, _ text: Formula) -> Action {
        let action = SetTextAction()
        action.setPosition(x, y)
        action.setText(text)
        action.setDuration(5)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        return action
    }

    open func createShowVariableAction(_ sprite: Sprite, _ sequence: SequenceAction, _ xPosition: Formula, _ yPosition: Formula, _ userVariable: UserVariable, _ androidStringProvider: AndroidStringProvider) -> Action {
        let action = ShowTextAction()
        action.setPosition(xPosition, yPosition)
        action.setVariableToShow(userVariable)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setAndroidStringProvider(androidStringProvider)
        return action
    }

    open func createShowVariableColorAndSizeAction(_ sprite: Sprite, _ sequence: SequenceAction, _ xPosition: Formula, _ yPosition: Formula, _ relativeTextSize: Formula, _ color: Formula, _ userVariable: UserVariable, _ alignment: Int, _ androidStringProvider: AndroidStringProvider) -> Action {
        let action = ShowTextColorSizeAlignmentAction()
        action.setPosition(xPosition, yPosition)
        action.setRelativeTextSize(relativeTextSize)
        action.setColor(color)
        action.setVariableToShow(userVariable)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setAlignment(alignment)
        action.setAndroidStringProvider(androidStringProvider)
        return action
    }

    open func createHideVariableAction(_ sprite: Sprite, _ userVariable: UserVariable, _ androidStringProvider: AndroidStringProvider) -> Action {
        let action = HideTextAction()
        action.setVariableToHide(userVariable)
        action.setSprite(sprite)
        action.setAndroidStringProvider(androidStringProvider)
        return action
    }

    open func createFlashAction(_ flashOn: Bool) -> Action {
        let action = FlashAction()
        action.setFlashOn(flashOn)
        return action
    }

    open func createVibrateAction(_ sprite: Sprite, _ sequence: SequenceAction, _ duration: Formula) -> Action {
        let action = VibrateAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDuration(duration)
        return action
    }

    open func createUpdateCameraPreviewAction(_ turnOn: Bool) -> Action {
        let action = CameraBrickAction()
        action.setActive(turnOn)
        return action
    }

    open func createFadeParticleEffectsAction(_ sprite: Sprite, _ turnOn: Bool) -> Action {
        let action = FadeParticleEffectAction()
        action.setFadeIn(turnOn)
        action.setSprite(sprite)
        action.setBackgroundSprite(ProjectManager.shared.currentlyPlayingScene.backgroundSprite)
        return action
    }

    open func createAdditiveParticleEffectsAction(_ sprite: Sprite, _ turnOn: Bool) -> Action {
        let action = AdditiveParticleEffectAction()
        action.setFadeIn(turnOn)
        action.setSprite(sprite)
        return action
    }

    open func createSetParticleColorAction(_ sprite: Sprite, _ color: Formula, _ sequence: SequenceAction) -> Action {
        let action = SetParticleColorAction()
        action.setColor(color)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        return action
    }

    open func createSetFrontCameraAction() -> Action {
        let action = ChooseCameraAction()
        action.setFrontCamera()
        return action
    }

    open func createSetBackCameraAction() -> Action {
        let action = ChooseCameraAction()
        action.setBackCamera()
        return action
    }

    open func createSendDigitalArduinoValueAction(_ sprite: Sprite, _ sequence: SequenceAction, _ pinNumber: Formula, _ pinValue: Formula) -> Action {
        let action = ArduinoSendDigitalValueAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPinNumber(pinNumber)
        action.setPinValue(pinValue)
        return action
    }

    open func createSendPWMArduinoValueAction(_ sprite: Sprite, _ sequence: SequenceAction, _ pinNumber: Formula, _ pinValue: Formula) -> Action {
        let action = ArduinoSendPWMValueAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPinNumber(pinNumber)
        action.setPinValue(pinValue)
        return action
    }

    open func createSendDigitalRaspiValueAction(_ sprite: Sprite, _ sequence: SequenceAction, _ pinNumber: Formula, _ pinValue: Formula) -> Action {
        let action = RaspiSendDigitalValueAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPinNumber(pinNumber)
        action.setPinValue(pinValue)
        return action
    }

    open func createSendRaspiPwmValueAction(_ sprite: Sprite, _ sequence: SequenceAction, _ pinNumber: Formula, _ pwmFrequency: Formula, _ pwmPercentage: Formula) -> Action {
        let action = RaspiPwmAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPinNumberFormula(pinNumber)
        action.setPwmFrequencyFormula(pwmFrequency)
        action.setPwmPercentageFormula(pwmPercentage)
        return action
    }

    open func createRaspiIfLogicActionAction(_ sprite: Sprite, _ sequence: SequenceAction, _ pinNumber: Formula, _ ifAction: Action, _ elseAction: Action?) -> Action {
        let action = RaspiIfLogicAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPinNumber(pinNumber)
        action.setIfAction(ifAction)
        action.setElseAction(elseAction)
        return action
    }

    open func createStopScriptAction(_ spinnerSelection: Int, _ currentScript: Script, _ sprite: Sprite) -> Action {
        switch spinnerSelection {
        case BrickValues.stopThisScript:
            let stopThisScriptAction = StopThisScriptAction()
            stopThisScriptAction.setCurrentScript(currentScript)
            return stopThisScriptAction
        case BrickValues.stopOtherScripts:
            let stopOtherScriptsAction = StopOtherScriptsAction()
            stopOtherScriptsAction.setCurrentScript(currentScript)
            stopOtherScriptsAction.setSprite(sprite)
            return stopOtherScriptsAction
        default:
            return StopAllScriptsAction()
        }
    }

    open func createReportAction(_ sprite: Sprite, _ sequence: SequenceAction, _ currentScript: Script, _ reportFormula: Formula) -> Action {
        if currentScript is UserDefinedScript {
            var reportAction = ReportAction()
            let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
            reportAction.setScope(scope)
            reportAction.setCurrentScript(currentScript)
            reportAction.setReportFormula(reportFormula)
            return reportAction
        } else {
            var stopThisScriptAction = StopThisScriptAction()
            stopThisScriptAction.setCurrentScript(currentScript)
            return stopThisScriptAction
        }
    }

    open func createSetNfcTagAction(_ sprite: Sprite, _ sequence: SequenceAction, _ nfcNdefMessage: Formula, _ nfcNdefSpinnerSelection: Int) -> Action {
        var setNfcTagAction = SetNfcTagAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        setNfcTagAction.setScope(scope)
        setNfcTagAction.setNfcTagNdefSpinnerSelection(nfcNdefSpinnerSelection)
        setNfcTagAction.setNfcNdefMessage(nfcNdefMessage)
        return setNfcTagAction
    }

    open func createAssertEqualsAction(_ sprite: Sprite, _ sequence: SequenceAction, _ actual: Formula, _ expected: Formula, _ position: String) -> Action {
        let action = AssertEqualsAction()
        action.setActualFormula(actual)
        action.setExpectedFormula(expected)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPosition(position)
        return action
    }

    open func createAssertUserListsAction(_ sprite: Sprite, _ sequence: SequenceAction, _ actual: UserList, _ expected: UserList, _ position: String) -> Action {
        let action = AssertUserListAction()
        action.setActualUserList(actual)
        action.setExpectedUserList(expected)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPosition(position)
        return action
    }

    open func createRepeatParameterizedAction(_ sprite: Sprite, _ data: ParameterizedData, _ parameters: [(UserList, UserVariable)], _ position: String, _ repeatedAction: Action, _ isLoopDelay: Bool) -> Action {
        let action = RepeatParameterizedAction()
        action.setParameterizedData(data)
        action.setParameters(parameters)
        action.setAction(repeatedAction)
        action.setLoopDelay(isLoopDelay)
        action.setSprite(sprite)
        action.setPosition(position)
        return action
    }

    open func createParameterizedAssertAction(_ sprite: Sprite, _ sequence: SequenceAction, _ actual: Formula, _ expected: UserList, _ data: ParameterizedData, _ position: String) -> Action {
        let action = ParameterizedAssertAction()
        action.setActualFormula(actual)
        action.setExpectedList(expected)
        action.setParameterizedData(data)
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setPosition(position)
        return action
    }

    open func createFinishStageAction(_ silent: Bool) -> Action {
        let action = FinishStageAction()
        action.setSilent(silent)
        return action
    }

    open func createTapAtAction(_ sprite: Sprite, _ sequence: SequenceAction, _ x: Formula, _ y: Formula) -> Action {
        let action = TapAtAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setStartX(x)
        action.setStartY(y)
        return action
    }

    open func createTapForAction(_ sprite: Sprite, _ sequence: SequenceAction, _ x: Formula, _ y: Formula, _ duration: Formula) -> Action {
        let action = TapAtAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDurationFormula(duration)
        action.setStartX(x)
        action.setStartY(y)
        return action
    }

    open func createTouchAndSlideAction(_ sprite: Sprite, _ sequence: SequenceAction, _ x: Formula, _ y: Formula, _ xChange: Formula, _ yChange: Formula, _ duration: Formula) -> Action {
        let action = TapAtAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setDurationFormula(duration)
        action.setStartX(x)
        action.setStartY(y)
        action.setChangeX(xChange)
        action.setChangeY(yChange)
        return action
    }

    open func createWriteVariableOnDeviceAction(_ userVariable: UserVariable) -> Action {
        let action = WriteUserDataOnDeviceAction()
        var projectDirectory = ProjectManager.shared.currentProject.directory
        var accessor = DeviceVariableAccessor(projectDirectory)
        action.setUserData(userVariable)
        action.setAccessor(accessor)
        return action
    }

    open func createWriteVariableToFileAction(_ sprite: Sprite, _ sequence: SequenceAction, _ variableFormula: Formula, _ userVariable: UserVariable) -> Action {
        let action = WriteVariableToFileAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setUserVariable(userVariable)
        action.setFormula(variableFormula)
        return action
    }

    open func createReadVariableFromFileAction(_ sprite: Sprite, _ sequence: SequenceAction, _ variableFormula: Formula, _ userVariable: UserVariable, _ deleteFile: Bool) -> Action {
        let action = ReadVariableFromFileAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setUserVariable(userVariable)
        action.setFormula(variableFormula)
        action.setDeleteFile(deleteFile)
        return action
    }

    open func createWriteListOnDeviceAction(_ userList: UserList) -> Action {
        let action = WriteUserDataOnDeviceAction()
        var projectDirectory = ProjectManager.shared.currentProject.directory
        var accessor = DeviceListAccessor(projectDirectory)
        var data = userList
        action.setUserData(data)
        action.setAccessor(accessor)
        return action
    }

    open func createWaitTillIdleAction() -> Action {
        return WaitTillIdleAction()
    }

    open func createReadVariableFromDeviceAction(_ userVariable: UserVariable) -> Action {
        let action = ReadVariableFromDeviceAction()
        action.setUserVariable(userVariable)
        return action
    }

    open func createReadListFromDeviceAction(_ userList: UserList) -> Action {
        let action = ReadListFromDeviceAction()
        action.setUserList(userList)
        return action
    }

    open func createWebRequestAction(_ sprite: Sprite, _ sequence: SequenceAction, _ variableFormula: Formula, _ userVariable: UserVariable) -> Action {
        let action = WebRequestAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(variableFormula)
        action.setUserVariable(userVariable)
        return action
    }

    open func createLookRequestAction(_ sprite: Sprite, _ sequence: SequenceAction, _ variableFormula: Formula) -> Action {
        let action = LookRequestAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(variableFormula)
        return action
    }

    open func createOpenUrlAction(_ sprite: Sprite, _ sequence: SequenceAction, _ variableFormula: Formula) -> Action {
        let action = OpenUrlAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(variableFormula)
        return action
    }

    open func createStartListeningAction(_ userVariable: UserVariable) -> Action {
        let action = StartListeningAction()
        action.setUserVariable(userVariable)
        return action
    }

    open func createSetListeningLanguageAction(_ listeningLanguageTag: String) -> Action {
        let action = SetListeningLanguageAction()
        action.listeningLanguageTag = listeningLanguageTag
        return action
    }

    open func createPaintNewLookAction(_ sprite: Sprite, _ sequence: SequenceAction, _ variableFormula: Formula, _ nextLookAction: SetNextLookAction) -> Action {
        let action = PaintNewLookAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(variableFormula)
        action.nextLookAction(nextLookAction)
        return action
    }

    open func createCopyLookAction(_ sprite: Sprite, _ sequence: SequenceAction, _ variableFormula: Formula, _ nextLookAction: SetNextLookAction) -> Action {
        let action = CopyLookAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.setFormula(variableFormula)
        action.nextLookAction(nextLookAction)
        return action
    }

    open func createEditLookAction(_ sprite: Sprite, _ sequence: SequenceAction, _ nextLookAction: SetNextLookAction) -> Action {
        let action = EditLookAction()
        let scope = Scope(project: ProjectManager.shared.currentProject, sprite: sprite, sequence: sequence)
        action.setScope(scope)
        action.nextLookAction(nextLookAction)
        return action
    }
}
