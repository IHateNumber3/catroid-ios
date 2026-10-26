import Foundation

public enum UserDataWrapper {
    public static func getUserVariable(_ name: String, _ scope: Scope) -> UserVariable? {
        var v = scope.sprite.getUserVariable(name)
        if let project = scope.project, v == nil {
            v = project.getUserVariable(name) ?? project.getMultiplayerVariable(name)
        }
        return v
    }

    public static func getUserList(_ name: String, _ scope: Scope) -> UserList? {
        var l = scope.sprite.getUserList(name)
        if let project = scope.project, l == nil { return project.getUserList(name) }
        return l
    }

    public static func getUserDefinedBrickInput(_ value: String, _ sequence: SequenceAction?) -> UserData? {
        if let seq = sequence as? ScriptSequenceAction, let script = seq.script as? UserDefinedScript {
            return script.getUserDefinedBrickInput(named: value)
        }
        return nil
    }

    public static func resetAllUserData(_ project: Project) {
        project.resetUserData()
        for scene in project.sceneList {
            for sprite in scene.spriteList { sprite.resetUserData() }
        }
    }
}
