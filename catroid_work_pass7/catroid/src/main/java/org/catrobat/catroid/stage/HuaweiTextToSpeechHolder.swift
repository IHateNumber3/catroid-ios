import Foundation
import UIKit
import AVFoundation

public class HuaweiTextToSpeechHolder {
    
    private static let tag = "HuaweiTextToSpeechHolder"
    
    public static let shared = HuaweiTextToSpeechHolder()
    private let synthesizer = AVSpeechSynthesizer()
    
    public init() {}
    
    public func initTextToSpeech(
        stageViewController: UIViewController,
        stageResourceHolder: StageResourceHolder
    ) {
        // На iOS встроенный движок синтеза речи доступен по умолчанию, 
        // поэтому сразу отмечаем ресурс как успешно инициализированный.
        print("[\(HuaweiTextToSpeechHolder.tag)] HMS Text-to-Speech bypassed in favor of native iOS AVFoundation.")
        stageResourceHolder.resourceInitialized()
    }
    
    public func textToSpeech(text: String) {
        guard !text.isEmpty else { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
        synthesizer.speak(utterance)
    }
}
