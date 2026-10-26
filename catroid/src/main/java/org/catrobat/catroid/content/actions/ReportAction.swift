import Foundation

open class ReportAction: Action {
    var currentScript: Script!
    var reportFormula: Formula!
    var scope: Scope!

    public override init() { super.init() }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    public func setCurrentScript(_ currentScript: Script) {
        self.currentScript = currentScript
    }

    public func setReportFormula(_ reportFormula: Formula) {
        self.reportFormula = reportFormula
    }

    public func getReportFormula() -> Formula {
        return self.reportFormula
    }

    public func getScope() -> Scope {
        return scope
    }

    open override func act(_ delta: Float) -> Bool {
        if actor is Look {
            (actor as! Look).stopThreadWithScript(currentScript)
        }
        return true
    }
}
