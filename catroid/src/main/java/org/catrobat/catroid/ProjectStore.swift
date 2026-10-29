
import Foundation

/// Filesystem storage for native Catrobat projects.
/// XML serialization and backward compatibility belong to ProjectSerializing.
public enum ProjectStore {
    private static let rootName = "CatroidProjects"

    public static var rootURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(rootName, isDirectory: true)
    }

    public static func directoryURL(for name: String) -> URL {
        let forbidden = CharacterSet(charactersIn: "/\\:\0")
        let safeName = name
            .components(separatedBy: forbidden)
            .joined(separator: "_")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return rootURL.appendingPathComponent(
            safeName.isEmpty ? "Untitled" : safeName,
            isDirectory: true
        )
    }

    @discardableResult
    public static func save(_ project: Project) -> Bool {
        guard let serializer = ProjectManager.serializer else {
            print("[ProjectStore] Native Catrobat serializer is not registered.")
            return false
        }

        do {
            let directory = directoryURL(for: project.name)

            try FileManager.default.createDirectory(
                at: directory,
                withIntermediateDirectories: true
            )

            project.directory = directory
            try serializer.saveProject(project)

            let xmlURL = directory.appendingPathComponent("code.xml")
            guard FileManager.default.fileExists(atPath: xmlURL.path) else {
                print("[ProjectStore] Serializer did not create code.xml.")
                return false
            }

            return true
        } catch {
            print("[ProjectStore] Save failed: \(error)")
            return false
        }
    }

    public static func projectNames() -> [String] {
        guard let directories = try? FileManager.default.contentsOfDirectory(
            at: rootURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else {
            return []
        }

        return directories.compactMap { directory in
            guard
                (try? directory.resourceValues(
                    forKeys: [.isDirectoryKey]
                ).isDirectory) == true,
                FileManager.default.fileExists(
                    atPath: directory.appendingPathComponent("code.xml").path
                )
            else {
                return nil
            }

            return directory.lastPathComponent
        }
        .sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }
    }

    public static func load(_ name: String) -> Project? {
        guard
            let serializer = ProjectManager.serializer
        else {
            print("[ProjectStore] Native Catrobat serializer is not registered.")
            return nil
        }

        let directory = directoryURL(for: name)
        let xmlURL = directory.appendingPathComponent("code.xml")

        guard FileManager.default.fileExists(atPath: xmlURL.path) else {
            print("[ProjectStore] Missing code.xml for \(name).")
            return nil
        }

        do {
            let project = try serializer.loadProject(directory)
            project.directory = directory
            return project
        } catch {
            print("[ProjectStore] Load failed: \(error)")
            return nil
        }
    }

    public static func delete(_ name: String) {
        do {
            let directory = directoryURL(for: name)

            if FileManager.default.fileExists(atPath: directory.path) {
                try FileManager.default.removeItem(at: directory)
            }
        } catch {
            print("[ProjectStore] Delete failed: \(error)")
        }
    }
}
