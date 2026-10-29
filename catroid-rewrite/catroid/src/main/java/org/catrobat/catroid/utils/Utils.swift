import Foundation
import CryptoKit
import Speech

public enum Utils {
    /// Utils.md5Checksum(File): hex в нижнем регистре
    public static func md5Checksum(_ file: URL) -> String {
        guard let data = try? Data(contentsOf: file, options: .mappedIfSafe) else { return "" }
        return Insecure.MD5.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }

    /// SPEECH_RECOGNITION_SUPPORTED_LANGUAGES: языковые теги, поддерживаемые распознаванием речи
    public static var speechRecognitionSupportedLanguages: [String] {
        return SFSpeechRecognizer.supportedLocales().map { $0.identifier.replacingOccurrences(of: "_", with: "-") }.sorted()
    }
}
