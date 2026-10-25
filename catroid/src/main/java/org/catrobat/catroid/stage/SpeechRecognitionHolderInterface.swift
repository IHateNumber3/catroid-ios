import Foundation
import UIKit

public protocol OnSpeechRecognitionResultCallback: AnyObject {
    func onResult(spokenWords: String)
}

public protocol SpeechRecognitionHolderInterface: AnyObject {
    var callback: OnSpeechRecognitionResultCallback? { get set }
    
    func forceSetLanguage()
    func initSpeechRecognition(
        stageViewController: StageViewController,
        stageResourceHolder: StageResourceHolder
    )
    func startListening()
    func destroy()
}
