import Foundation
import UIKit

public class HmsSpeechRecognitionHolder: SpeechRecognitionHolderInterface {
    
    public var callback: OnSpeechRecognitionResultCallback?
    private weak var viewController: UIViewController?
    
    public init() {}
    
    public func forceSetLanguage() {
        // На iOS локаль управляется нативным фреймворком Speech
    }
    
    public func initSpeechRecognition(stageViewController: UIViewController, stageResourceHolder: StageResourceHolder) {
        self.viewController = stageViewController
        // На iOS HMS не используется, сразу сообщаем об успешной инициализации ресурса
        stageResourceHolder.resourceInitialized()
    }
    
    public func startListening() {
        // На iOS запуск распознавания делегируется стандартному механизму
        print("[HmsSpeechRecognitionHolder] Using native Apple Speech recognition framework instead of HMS.")
    }
    
    public func destroy() {
        callback = nil
        viewController = nil
    }
}
