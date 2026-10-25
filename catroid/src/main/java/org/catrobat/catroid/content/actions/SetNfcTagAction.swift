import Foundation

open class SetNfcTagAction: Action {
    var scope: Scope!
    var nfcNdefMessage: Formula!
    var nfcTagNdefSpinnerSelection: Int = 0
    var message: NdefMessage!
    var firstExecution: Bool = true
    public static let TAG: String = SetNfcTagAction.class.getSimpleName()

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
        if nfcNdefMessage == nil {
            return true
        }
        if firstExecution {
            do {
                try message = NfcHandler.createMessage(nfcNdefMessage.interpretString(scope), nfcTagNdefSpinnerSelection)
                // TODO(port): synchronized (StageActivity.class) { StageActivity.setNfcTagMessage(message);
                } firstExecution = false;
            } catch let e {
                Log.d(TAG, "No new message was added to the Stage", e)
                return true
            }
        }
        return StageActivity.nfcTagMessage != message
    }
}
