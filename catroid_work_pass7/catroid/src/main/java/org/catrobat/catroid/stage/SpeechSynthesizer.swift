import Foundation
import AVFoundation

public class SpeechSynthesizer {
    
    private static let tag = "SpeechSynthesizer"
    
    public var scope: Any? // Замени на модель Scope проекта
    public var text: String? // Текст или формула для синтеза
    public private(set) var speechFile: URL?
    
    private var onErrorCallback: (() -> Void)?
    private var onDoneCallback: (() -> Void)?
    
    public init(scope: Any?, text: String?) {
        self.scope = scope
        self.text = text
    }
    
    /// Синтез речи на iOS
    public func synthesize() {
        guard let textToSpeech = text, !textToSpeech.isEmpty else {
            onDoneCallback?()
            return
        }
        
        // Генерация хеша для имени файла (аналог MD5)
        let hashText = md5(string: textToSpeech)
        let tmpDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("TextToSpeech_Tmp", isDirectory: true)
        
        try? FileManager.default.createDirectory(at: tmpDirectory, withIntermediateDirectories: true, attributes: nil)
        
        let fileURL = tmpDirectory.appendingPathComponent("\(hashText).wav")
        self.speechFile = fileURL
        
        // Вызов синтезатора через наш TextToSpeechHolder на iOS
        TextToSpeechHolder.shared.textToSpeech(
            text: textToSpeech,
            speechFile: fileURL,
            speakParameters: [:]
        )
        
        // Уведомление о завершении (синхронно/асинхронно)
        onDoneCallback?()
    }
    
    public func setUtteranceProgressListener(onError: @escaping () -> Void, onDone: @escaping () -> Void) {
        self.onErrorCallback = onError
        self.onDoneCallback = onDone
    }
    
    public func setHuaweiTextToSpeechListener(onError: @escaping () -> Void, onDone: @escaping () -> Void) {
        // На iOS Huawei TTS не используется, перенаправляем на стандартные колбеки
        self.onErrorCallback = onError
        self.onDoneCallback = onDone
    }
    
    private func md5(string: String) -> String {
        // Простой хелпер для генерации уникального имени файла на основе текста
        return String(string.hashAbsolute)
    }
}

private extension String {
    var hashAbsolute: Int {
        return abs(self.hashValue)
    }
}
