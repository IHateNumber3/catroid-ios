import Foundation

public class FormulaEditorClipboard {
    
    // Эквивалент поля clipboard с токенами
    public private(set) var clipboard: [InternToken]?
    
    private weak var formulaEditor: FormulaEditorEditTextProtocol?
    
    public init(formulaEditor: FormulaEditorEditTextProtocol) {
        self.formulaEditor = formulaEditor
    }
    
    private func cloneTokens(_ tokens: [InternToken]) -> [InternToken] {
        return tokens.map { $0.deepCopy() }
    }
    
    private func copyTokens(_ tokens: [InternToken]?) {
        if let tokens = tokens {
            clipboard = cloneTokens(tokens)
        } else {
            clipboard = nil
        }
    }
    
    public func copy() {
        guard let editor = formulaEditor else { return }
        copyTokens(editor.selectedTokens)
    }
    
    public func checkIfSelectedAndCopy() {
        guard let editor = formulaEditor else { return }
        if let selected = editor.selectedTokens, !selected.isEmpty {
            copyTokens(selected)
        } else {
            copyTokens(editor.internFormula.internTokenFormulaList)
        }
    }
    
    public func paste() {
        guard let clipboard = clipboard, let editor = formulaEditor else { return }
        let cloned = cloneTokens(clipboard)
        editor.addTokens(cloned)
    }
}

// Протокол для взаимодействия с редактором формул на iOS
public protocol FormulaEditorEditTextProtocol: AnyObject {
    var selectedTokens: [InternToken]? { get }
    var internFormula: InternFormula { get }
    func addTokens(_ tokens: [InternToken])
}
