import Foundation
import UIKit

public class SpeechRecognitionHolderFactory {
    
    private static let dummy: SpeechRecognitionHolderInterface = DummySpeechRecognitionHolder()
    
    private let gmsSpeechRecognitionHolder: SpeechRecognitionHolderInterface
    private let hmsSpeechRecognitionHolder: SpeechRecognitionHolderInterface
    
    public private(set) var instance: SpeechRecognitionHolderInterface
    
    public init(
        gmsSpeechRecognitionHolder: SpeechRecognitionHolderInterface,
        hmsSpeechRecognitionHolder: SpeechRecognitionHolderInterface
    ) {
        self.gmsSpeechRecognitionHolder = gmsSpeechRecognitionHolder
        self.hmsSpeechRecognitionHolder = hmsSpeechRecognitionHolder
        self.instance = SpeechRecognitionHolderFactory.dummy
    }
    
    /// Проверка доступности распознавания речи на устройстве (на iOS всегда доступно на поддерживаемых моделях)
    public func isRecognitionAvailable(viewController: UIViewController) -> Bool {
        // На iOS мы используем встроенный Apple Speech Framework, 
        // поэтому всегда возвращаем gms-эквивалент (нативный рекогнайзер)
        self.instance = gmsSpeechRecognitionHolder
        return true
    }
}

// MARK: - Dummy Implementation for iOS
fileprivate class DummySpeechRecognitionHolder: SpeechRecognitionHolderInterface {
    var callback: OnSpeechRecognitionResultCallback? = nil
    
    func forceSetLanguage() {}
    
    func initSpeechRecognition(stageViewController: UIViewController, stageResourceHolder: StageResourceHolder) {}
    
    func startListening() {}
    
    func destroy() {}
}
