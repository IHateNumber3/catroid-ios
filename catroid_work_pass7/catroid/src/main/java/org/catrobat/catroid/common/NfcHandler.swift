import Foundation

/// NFC-сообщение (замена android.nfc.NdefMessage). CoreNFC подключается позже.
public struct NdefMessage {
    public var payload: String
    public var type: Int
    public init(payload: String, type: Int) { self.payload = payload; self.type = type }
}

public enum NfcHandler {
    public static var lastTagMessage: String = ""
    public static var lastTagId: String = ""

    public static func getLastNfcTagMessage() -> String { return lastTagMessage }
    public static func getLastNfcTagId() -> String { return lastTagId }

    public static func createMessage(_ message: String, _ spinnerSelection: Int) -> NdefMessage {
        return NdefMessage(payload: message, type: spinnerSelection)
    }
}
