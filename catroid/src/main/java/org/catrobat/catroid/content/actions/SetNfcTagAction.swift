import Foundation

open class SetNfcTagAction: Action {
    var scope: Scope!
    var nfcNdefMessage: Formula!
    var nfcTagNdefSpinnerSelection: Int = 0
    var message: Any!
    var firstExecution: Bool = true
    public static let TAG: String = String(describing: SetNfcTagAction.self)

    public required init() { super.init() }

    public func setNfcTagNdefSpinnerSelection(_ spinnerSelection: Int) {
        self.nfcTagNdefSpinnerSelection = spinnerSelection
    }

    public func setNfcNdefMessage(_ nfcNdefMessage: Formula) {
        self.nfcNdefMessage = nfcNdefMessage
    }

    public func setScope(_ scope: Scope) {
        self.scope = scope
    }

    open override func restart() {
        super.restart()
        firstExecution = true
    }

    open override func act(_ delta: Float) -> Bool {
        // Аппаратное действие (Bluetooth/NFC) на iOS не поддерживается
        return true
    }
}
