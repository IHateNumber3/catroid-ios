import Foundation
import CoreGraphics

public enum FormulaElementOperations {

    public static func getLookLayerIndex(_ sprite: Sprite?, _ look: Look, _ spriteList: [Sprite?]) -> Double {
        let z = look.zIndex
        if z == 0 { return 0.0 }
        if z < 0 { return Double(spriteList.firstIndex { $0 == sprite } ?? -1) }
        return Double(z - Constants.zIndexNumberVirtualLayers)
    }

    public static func equalsDoubleIEEE754(_ left: Double, _ right: Double) -> Bool {
        return (left.isNaN && right.isNaN) || (!left.isNaN && !right.isNaN && left >= right && left <= right)
    }

    public static func interpretOperatorEqual(_ left: Any, _ right: Any) -> Bool {
        let l = JavaCompat.string(left), r = JavaCompat.string(right)
        if let ld = JavaCompat.parseDouble(l), let rd = JavaCompat.parseDouble(r) {
            return equalsDoubleIEEE754(ld, rd)
        }
        return l == r
    }

    public static func tryInterpretDoubleValue(_ obj: Any?) -> Double {
        if let s = obj as? String { return JavaCompat.parseDouble(s) ?? Double.nan }
        return (obj as? Double) ?? 0.0
    }

    public static func normalizeDegeneratedDoubleValues(_ value: Any?) -> Any {
        switch value {
        case let s as String: return s
        case let c as Character: return c
        case let b as Bool: return Conversions.booleanToDouble(b)
        case let i as Int: return Double(i)
        case let d as Double:
            if d == -Double.infinity { return -Double.greatestFiniteMagnitude }
            if d == Double.infinity { return Double.greatestFiniteMagnitude }
            return d
        default: return 0.0
        }
    }

    public static func isInteger(_ value: Double) -> Bool {
        return value.isFinite && value == JavaCompat.round(value)
    }

    public static func tryGetLookNumber(_ lookData: LookData?, _ list: [LookData]) -> Double {
        guard let ld = lookData else { return 1.0 }
        return Double((list.firstIndex { $0 == ld } ?? -1) + 1)
    }

    public static func getLookName(_ lookData: LookData?) -> String { return lookData?.name ?? "" }

    public static func getNumberOfLooks(_ lookData: LookData?, _ list: [LookData]) -> Int {
        return lookData?.isWebRequest == true ? list.count + 1 : list.count
    }

    public static func tryCalculateCollidesWithEdge(_ look: Look, _ stageListener: StageListener?, _ screen: CGRect?) -> Double {
        if stageListener?.firstFrameDrawn == true, let screen = screen {
            return Conversions.booleanToDouble(CollisionDetection.collidesWithEdge(look.getCurrentCollisionPolygon(), screen))
        }
        return Conversions.FALSE
    }

    public static func calculateCollidesWithFinger(_ look: Look) -> Double {
        return CollisionDetection.collidesWithFinger(look.getCurrentCollisionPolygon(), TouchUtil.getCurrentTouchingPoints())
    }

    public static func interpretObjectSensor(_ sensor: Sensors?, _ sprite: Sprite, _ editedScene: Scene, _ project: Project) -> Any {
        let look = sprite.look!
        let lookDataList = sprite.lookList
        let lookData = look.lookData ?? lookDataList.first
        switch sensor {
        case .objectBrightness?: return Double(look.brightnessInUserInterfaceDimensionUnit)
        case .objectColor?: return Double(look.colorInUserInterfaceDimensionUnit)
        case .objectTransparency?: return Double(look.transparencyInUserInterfaceDimensionUnit)
        case .objectLayer?: return getLookLayerIndex(sprite, look, editedScene.spriteList)
        case .motionDirection?: return Double(look.motionDirectionInUserInterfaceDimensionUnit)
        case .lookDirection?: return Double(look.lookDirectionInUserInterfaceDimensionUnit)
        case .objectSize?: return Double(look.sizeInUserInterfaceDimensionUnit)
        case .objectX?: return Double(look.xInUserInterfaceDimensionUnit)
        case .objectY?: return Double(look.yInUserInterfaceDimensionUnit)
        case .objectAngularVelocity?: return Double(look.angularVelocityInUserInterfaceDimensionUnit)
        case .objectXVelocity?: return Double(look.xVelocityInUserInterfaceDimensionUnit)
        case .objectYVelocity?: return Double(look.yVelocityInUserInterfaceDimensionUnit)
        case .objectDistanceTo?: return Double(look.distanceToTouchPositionInUserInterfaceDimensions)
        case .objectLookNumber?, .objectBackgroundNumber?: return tryGetLookNumber(lookData, lookDataList)
        case .objectNumberOfLooks?: return Double(getNumberOfLooks(lookData, lookDataList))
        case .objectLookName?, .objectBackgroundName?: return getLookName(lookData)
        case .nfcTagMessage?: return NfcHandler.getLastNfcTagMessage()
        case .nfcTagId?: return NfcHandler.getLastNfcTagId()
        case .collidesWithEdge?:
            return tryCalculateCollidesWithEdge(look, StageActivity.stageListener, project.getScreenRectangle())
        case .collidesWithFinger?: return calculateCollidesWithFinger(look)
        default: return Conversions.FALSE
        }
    }

    public static func getAllClones(_ sprite: Sprite, _ stageListener: StageListener?) -> [Sprite] {
        if let l = stageListener { return [sprite] + l.getAllClonesOfSprite(sprite) }
        return [sprite]
    }

    public static func interpretUserList(_ userList: UserList?) -> Any {
        guard let list = userList else { return Conversions.FALSE }
        if list.value.isEmpty { return "" }
        if list.value.count == 1 { return list.value[0] }
        return interpretMultipleItemsUserList(list.value)
    }

    private static func booleanToLocalizedString(_ value: Bool) -> String {
        return value ? NSLocalizedString("formula_editor_true", value: "true", comment: "")
                     : NSLocalizedString("formula_editor_false", value: "false", comment: "")
    }

    private static func interpretMultipleItemsUserList(_ values: [Any]) -> Any {
        let strings: [String] = values.map { item in
            switch item {
            case let i as Int: return trimTrailingCharacters(String(i))
            case let d as Double: return trimTrailingCharacters(JavaCompat.double(d))
            case let b as Bool: return trimTrailingCharacters(booleanToLocalizedString(b))
            case let c as Character: return trimTrailingCharacters(String(c))
            default: return trimTrailingCharacters(item as? String ?? JavaCompat.string(item))
            }
        }
        let separator = strings.contains { $0.count > 1 } ? " " : ""
        var out = ""
        for s in strings { out += trimTrailingCharacters(s) + separator }
        return out.trimmingCharacters(in: CharacterSet(charactersIn: " ").union(.controlCharacters))
    }

    public static func interpretUserVariable(_ v: UserVariable?) -> Any { return v?.value ?? Conversions.FALSE }

    public static func interpretUserDefinedBrickInput(_ input: UserData?) -> Any {
        guard let input = input else { return Conversions.FALSE }
        if let v = input as? UserVariable { return interpretUserVariable(v) }
        if let l = input as? UserList { return interpretUserList(l) }
        return 0
    }

    public static func interpretLookCollision(_ look: Look, _ looks: [Look]) -> Double {
        let collides = looks.contains { look !== $0 && CollisionDetection.checkCollisionBetweenLooks(look, $0) }
        return Conversions.booleanToDouble(collides)
    }

    public static func toLooks(_ sprites: [Sprite]) -> [Look] { return sprites.map { $0.look } }

    public static func interpretSensor(_ sprite: Sprite, _ editedScene: Scene, _ project: Project, _ value: String?) -> Any {
        guard let sensor = Sensors.getSensorByValue(value) else { return Conversions.FALSE }
        if sensor.isObjectSensor {
            return interpretObjectSensor(sensor, sprite, editedScene, project)
        }
        return SensorHandler.getSensorValue(sensor)
    }

    public static func tryFindSprite(_ scene: Scene, _ name: String?) -> Sprite? {
        guard let name = name else { return nil }
        return scene.getSprite(name)
    }

    public static func interpretCollision(_ firstLook: Look, _ secondSpriteName: String?, _ scene: Scene,
                                          _ stageListener: StageListener?) -> Double {
        guard let second = tryFindSprite(scene, secondSpriteName) else { return Conversions.FALSE }
        let sprites: [Sprite]
        if second is GroupSprite {
            sprites = GroupSprite.getSpritesFromGroup(withGroupName: secondSpriteName ?? "", sprites: scene.spriteList)
        } else {
            sprites = getAllClones(second, stageListener)
        }
        return interpretLookCollision(firstLook, toLooks(sprites))
    }

    public static func tryInterpretCollision(_ firstLook: Look, _ secondSpriteName: String?, _ scene: Scene?,
                                             _ stageListener: StageListener?) -> Double {
        guard let scene = scene else { return Conversions.FALSE }
        return interpretCollision(firstLook, secondSpriteName, scene, stageListener)
    }

    public static func tryInterpretElementRecursive(_ element: FormulaElement, _ scope: Scope?) -> Any {
        guard let scope = scope else { return Double.nan }
        return element.interpretRecursive(scope)
    }

    public static func tryParseIntFromObject(_ value: Any) -> Int {
        if let s = value as? String { return JavaCompat.parseDouble(s).map { JavaCompat.int($0) } ?? 0 }
        return JavaCompat.int((value as? Double) ?? 0)
    }
}
