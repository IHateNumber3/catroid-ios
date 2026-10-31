import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

/// Small lossless XML tree used by the Catrobat XStream compatibility layer.
/// It intentionally preserves unknown elements and attributes instead of dropping them.
public final class CatrobatXMLNode {
    public var name: String
    public var attributes: [String: String]
    public var text: String
    public var children: [CatrobatXMLNode]

    public init(name: String, attributes: [String: String] = [:], text: String = "", children: [CatrobatXMLNode] = []) {
        self.name = name
        self.attributes = attributes
        self.text = text
        self.children = children
    }

    public subscript(child name: String) -> CatrobatXMLNode? {
        return children.first { $0.name == name }
    }

    public func descendants(named target: String) -> [CatrobatXMLNode] {
        var result: [CatrobatXMLNode] = []
        for child in children {
            if child.name == target { result.append(child) }
            result.append(contentsOf: child.descendants(named: target))
        }
        return result
    }

    public func xmlString() -> String {
        let attrs = attributes.keys.sorted().map { key in
            " \(key)=\"\(Self.escape(attributes[key] ?? "", attribute: true))\""
        }.joined()
        if children.isEmpty && text.isEmpty { return "<\(name)\(attrs)/>" }
        let body = Self.escape(text, attribute: false) + children.map { $0.xmlString() }.joined()
        return "<\(name)\(attrs)>\(body)</\(name)>"
    }

    private static func escape(_ value: String, attribute: Bool) -> String {
        var result = value.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
        if attribute {
            result = result.replacingOccurrences(of: "\"", with: "&quot;")
                .replacingOccurrences(of: "'", with: "&apos;")
        }
        return result
    }
}

public enum CatrobatXMLArchiveError: Error {
    case malformedXML(String)
    case missingScriptList
    case objectNotFound(String)
}

private final class CatrobatXMLTreeParser: NSObject, XMLParserDelegate {
    private(set) var root: CatrobatXMLNode?
    private var stack: [CatrobatXMLNode] = []
    private var parseError: Error?

    func parser(_ parser: XMLParser, didStartElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        let node = CatrobatXMLNode(name: elementName, attributes: attributeDict)
        if let parent = stack.last { parent.children.append(node) }
        else { root = node }
        stack.append(node)
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        stack.last?.text += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String,
                namespaceURI: String?, qualifiedName qName: String?) {
        if !stack.isEmpty { stack.removeLast() }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parseError = parseError
    }

    static func parse(_ data: Data) throws -> CatrobatXMLNode {
        let delegate = CatrobatXMLTreeParser()
        let parser = XMLParser(data: data)
        parser.delegate = delegate
        parser.shouldResolveExternalEntities = false
        guard parser.parse(), let root = delegate.root else {
            throw CatrobatXMLArchiveError.malformedXML(String(describing: delegate.parseError ?? parser.parserError ?? NSError(domain: "CatrobatXML", code: 1)))
        }
        return root
    }
}

/// A brick unknown to this iOS build remains in the script as an inert model object.
/// Its original XML (including formulas and custom fields) is written back unchanged.
public final class ArchivedBrick: BrickBaseType {
    public var archivedTypeName = ""
    public required init() { super.init() }
}

/// Fallback for script subclasses not yet ported to the iOS target.
public final class ArchivedScript: Script {
    public var archivedTypeName = ""
    public override var scriptBrick: ScriptBrick {
        if cachedScriptBrick == nil { cachedScriptBrick = EmptyEventBrick(script: self) }
        return cachedScriptBrick!
    }
    public override func createEventId(for sprite: Sprite) -> EventId? { return nil }
}

/// Decoder for XStream's <script type="..."> and <brick type="..."> nodes.
/// The raw node is retained on every decoded object, so unported parameters survive a save.
public enum CatrobatScriptArchiveCodec {
    public static func parse(_ data: Data) throws -> CatrobatXMLNode {
        return try CatrobatXMLTreeParser.parse(data)
    }

    public static func decodeScriptList(from objectNode: CatrobatXMLNode) -> [Script] {
        guard let list = objectNode[child: "scriptList"] else { return [] }
        return list.children.filter { $0.name == "script" }.map(decodeScript)
    }

    /// Convenience entry point for a real code.xml file and an already-created Sprite model.
    public static func restoreScripts(on sprite: Sprite, from codeXML: Data) throws {
        let root = try parse(codeXML)
        guard let objectNode = root.descendants(named: "object").first(where: {
            $0.attributes["name"] == sprite.name
        }) else {
            throw CatrobatXMLArchiveError.objectNotFound(sprite.name)
        }
        restoreScripts(on: sprite, from: objectNode)
    }

    public static func restoreScripts(on sprite: Sprite, from objectNode: CatrobatXMLNode) {
        sprite.removeAllScripts()
        for script in decodeScriptList(from: objectNode) { sprite.addScript(script) }
    }

    public static func encodeScriptList(_ scripts: [Script]) -> CatrobatXMLNode {
        return CatrobatXMLNode(name: "scriptList", children: scripts.map(encodeScript))
    }

    public static func encodeScript(_ script: Script) -> CatrobatXMLNode {
        // The retained XStream subtree is authoritative until field-by-field writers exist.
        if let original = script.catrobatXMLArchive { return original }
        let typeName = String(describing: type(of: script))
        let brickNodes = script.brickList.map(encodeBrick)
        return CatrobatXMLNode(name: "script", attributes: ["type": typeName], children: [
            CatrobatXMLNode(name: "posX", text: String(script.posX)),
            CatrobatXMLNode(name: "posY", text: String(script.posY)),
            CatrobatXMLNode(name: "commentedOut", text: String(script.commentedOut)),
            CatrobatXMLNode(name: "brickList", children: brickNodes)
        ])
    }

    public static func encodeBrick(_ brick: Brick) -> CatrobatXMLNode {
        if let original = (brick as? BrickBaseType)?.catrobatXMLArchive { return original }
        let typeName = (brick as? ArchivedBrick)?.archivedTypeName ?? String(describing: type(of: brick))
        return CatrobatXMLNode(name: "brick", attributes: ["type": typeName])
    }

    private static func decodeScript(_ node: CatrobatXMLNode) -> Script {
        let typeName = node.attributes["type"] ?? ""
        let script = makeScript(typeName) ?? ArchivedScript()
        if let archived = script as? ArchivedScript { archived.archivedTypeName = typeName }
        script.catrobatXMLArchive = node
        script.posX = Float(node[child: "posX"]?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0") ?? 0
        script.posY = Float(node[child: "posY"]?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? "0") ?? 0
        let isCommentedOut = node[child: "commentedOut"]?.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if let brickList = node[child: "brickList"] {
            for brickNode in brickList.children where brickNode.name == "brick" {
                script.addBrick(decodeBrick(brickNode))
            }
        }
        if let value = isCommentedOut { script.setCommentedOut(value == "true" || value == "1") }
        script.catrobatXMLArchive = node
        script.setParents()
        return script
    }

    private static func decodeBrick(_ node: CatrobatXMLNode) -> Brick {
        let typeName = node.attributes["type"] ?? ""
        let brick = makeBrick(typeName) ?? ArchivedBrick()
        if let archived = brick as? ArchivedBrick { archived.archivedTypeName = typeName }
        let base = brick
        base.catrobatXMLArchive = node
        if let value = node[child: "commentedOut"]?.text.trimmingCharacters(in: .whitespacesAndNewlines) {
            base.setCommentedOut(value == "true" || value == "1")
        }
        if let composite = brick as? CompositeBrick {
            if let nested = node[child: "nestedBricks"] {
                composite.nestedBricks = nested.children.filter { $0.name == "brick" }.map(decodeBrick)
            }
            if let secondary = node[child: "secondaryNestedBricks"] {
                composite.secondaryNestedBricks = secondary.children.filter { $0.name == "brick" }.map(decodeBrick)
            }
            for child in composite.nestedBricks + composite.secondaryNestedBricks { child.setParent(brick) }
        }
        return brick
    }

    private static func makeScript(_ name: String) -> Script? {
        switch name {
        case "StartScript": return StartScript()
        case "WhenScript": return WhenScript()
        case "WhenConditionScript": return WhenConditionScript()
        case "WhenClonedScript": return WhenClonedScript()
        case "WhenTouchDownScript": return WhenTouchDownScript()
        case "WhenBackgroundChangesScript": return WhenBackgroundChangesScript()
        case "WhenBounceOffScript": return WhenBounceOffScript()
        case "WhenNfcScript": return WhenNfcScript()
        case "WhenGamepadButtonScript": return WhenGamepadButtonScript()
        case "BroadcastScript": return BroadcastScript()
        case "RaspiInterruptScript": return RaspiInterruptScript()
        case "UserDefinedScript": return UserDefinedScript()
        case "EmptyScript": return EmptyScript()
        default: return nil
        }
    }

    /// Known Swift brick implementations are instantiated as their real model classes.
    /// All other aliases are retained as ArchivedBrick instead of being discarded.
    private static func makeBrick(_ name: String) -> BrickBaseType? {
        switch name {
        case "MoveNStepsBrick": return MoveNStepsBrick()
        case "GoNStepsBackBrick": return GoNStepsBackBrick()
        case "TurnLeftBrick": return TurnLeftBrick()
        case "TurnRightBrick": return TurnRightBrick()
        case "SetXBrick": return SetXBrick()
        case "SetYBrick": return SetYBrick()
        case "SetSizeToBrick": return SetSizeToBrick()
        case "ChangeSizeByNBrick": return ChangeSizeByNBrick()
        case "SetLookByIndexBrick": return SetLookByIndexBrick()
        case "WaitBrick": return WaitBrick()
        case "RepeatBrick": return RepeatBrick()
        case "RepeatUntilBrick": return RepeatUntilBrick()
        case "ForeverBrick": return ForeverBrick()
        case "IfLogicBeginBrick": return IfLogicBeginBrick()
        case "IfThenLogicBeginBrick": return IfThenLogicBeginBrick()
        case "IfLogicElseBrick": return IfLogicElseBrick()
        case "IfLogicEndBrick": return IfLogicEndBrick()
        case "IfThenLogicEndBrick": return IfThenLogicEndBrick()
        case "ShowBrick": return ShowBrick()
        case "HideBrick": return HideBrick()
        case "ComeToFrontBrick": return ComeToFrontBrick()
        case "ClearBackgroundBrick": return ClearBackgroundBrick()
        case "PenDownBrick": return PenDownBrick()
        case "PenUpBrick": return PenUpBrick()
        case "SetPenSizeBrick": return SetPenSizeBrick()
        case "ResetTimerBrick": return ResetTimerBrick()
        case "StopAllSoundsBrick": return StopAllSoundsBrick()
        case "SpeakBrick": return SpeakBrick()
        case "SpeakAndWaitBrick": return SpeakAndWaitBrick()
        case "ThinkBubbleBrick": return ThinkBubbleBrick()
        case "ThinkForBubbleBrick": return ThinkForBubbleBrick()
        case "SetVolumeToBrick": return SetVolumeToBrick()
        case "ChangeVolumeByNBrick": return ChangeVolumeByNBrick()
        case "SetBrightnessBrick": return SetBrightnessBrick()
        case "ChangeBrightnessByNBrick": return ChangeBrightnessByNBrick()
        case "SetTransparencyBrick": return SetTransparencyBrick()
        case "ChangeTransparencyByNBrick": return ChangeTransparencyByNBrick()
        case "SetColorBrick": return SetColorBrick()
        case "ChangeColorByNBrick": return ChangeColorByNBrick()
        case "PointInDirectionBrick": return PointInDirectionBrick()
        case "IfOnEdgeBounceBrick": return IfOnEdgeBounceBrick()
        case "StampBrick": return StampBrick()
        case "VibrationBrick": return VibrationBrick()
        default: return nil
        }
    }
}
