import Foundation

/// Per-project Catrobat directory storage. XML is kept at the standard code.xml path.
/// This Swift implementation currently serializes the header and scene/object names;
/// full XStream brick/formula converters and historical migration parity still need porting.
public enum ProjectStore {
    private static let rootName = "CatroidProjects"
    private static var rootURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(rootName, isDirectory: true)
    }

    private static func safeName(_ name: String) -> String {
        let forbidden = CharacterSet(charactersIn: "/\\:\0")
        let cleaned = name.components(separatedBy: forbidden).joined(separator: "_").trimmingCharacters(in: .whitespacesAndNewlines)
        return cleaned.isEmpty ? "Untitled" : cleaned
    }

    public static func directoryURL(for name: String) -> URL {
        rootURL.appendingPathComponent(safeName(name), isDirectory: true)
    }

    @discardableResult public static func save(_ project: Project) -> Bool {
        do {
            let dir = directoryURL(for: project.name)
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: dir.appendingPathComponent("images", isDirectory: true), withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: dir.appendingPathComponent("sounds", isDirectory: true), withIntermediateDirectories: true)
            project.directory = dir
            let xml = makeXML(project)
            try xml.write(to: dir.appendingPathComponent("code.xml"), atomically: true, encoding: .utf8)
            return true
        } catch {
            print("[ProjectStore] Catrobat save failed: \(error)")
            return false
        }
    }

    public static func projectNames() -> [String] {
        guard let urls = try? FileManager.default.contentsOfDirectory(at: rootURL, includingPropertiesForKeys: [.isDirectoryKey]) else { return [] }
        return urls.filter { url in
            (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true &&
            FileManager.default.fileExists(atPath: url.appendingPathComponent("code.xml").path)
        }.map { $0.lastPathComponent }.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
    }

    public static func load(_ name: String) -> Project? {
        let dir = directoryURL(for: name)
        let xmlURL = dir.appendingPathComponent("code.xml")
        guard let data = try? Data(contentsOf: xmlURL),
              let document = try? XMLDocument(data: data),
              let root = document.rootElement(), root.name == "program" else { return nil }
        let header = root.elements(forName: "header").first
        let projectName = header?.elements(forName: "programName").first?.stringValue ?? name
        let landscape = (header?.elements(forName: "landscapeMode").first?.stringValue ?? "false") == "true"
        let project = Project(name: projectName, landscapeMode: landscape)
        project.directory = dir
        project.description = header?.elements(forName: "description").first?.stringValue ?? ""
        if let version = header?.elements(forName: "catrobatLanguageVersion").first?.stringValue, let number = Double(version) {
            project.catrobatLanguageVersion = number
        }
        // This minimal reader deliberately does not claim to restore bricks/formulas.
        // Keep a valid default scene when the XML has no scenes recognized by this port.
        if project.sceneList.isEmpty {
            let scene = Scene(name: NSLocalizedString("default_scene_name", value: "Scene", comment: ""), project: project)
            scene.addSprite(Sprite(name: NSLocalizedString("background", value: "Background", comment: "")))
            project.addScene(scene)
        }
        return project
    }

    public static func delete(_ name: String) {
        try? FileManager.default.removeItem(at: directoryURL(for: name))
    }

    private static func makeXML(_ project: Project) -> String {
        func esc(_ value: String) -> String {
            value.replacingOccurrences(of: "&", with: "&amp;")
                .replacingOccurrences(of: "<", with: "&lt;")
                .replacingOccurrences(of: ">", with: "&gt;")
                .replacingOccurrences(of: "\"", with: "&quot;")
                .replacingOccurrences(of: "'", with: "&apos;")
        }
        let h = project.xmlHeader
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>\n<program><header>"
        xml += "<programName>\(esc(project.name))</programName>"
        xml += "<description>\(esc(project.description))</description>"
        xml += "<notesAndCredits>\(esc(project.notesAndCredits))</notesAndCredits>"
        xml += "<screenWidth>\(h.virtualScreenWidth)</screenWidth><screenHeight>\(h.virtualScreenHeight)</screenHeight>"
        xml += "<catrobatLanguageVersion>\(h.catrobatLanguageVersion)</catrobatLanguageVersion>"
        xml += "<landscapeMode>\(h.landscapeMode)</landscapeMode><scenesEnabled>true</scenesEnabled></header><scenes>"
        for scene in project.sceneList {
            xml += "<scene><name>\(esc(scene.name))</name><objectList>"
            for sprite in scene.spriteList { xml += "<sprite><name>\(esc(sprite.name))</name></sprite>" }
            xml += "</objectList></scene>"
        }
        xml += "</scenes></program>"
        return xml
    }
}
