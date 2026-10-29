import Foundation
import Speech
import AVFoundation
import UIKit

public protocol OnSpeechRecognitionResultCallback: AnyObject {
    func onResult(_ result: String)
}

public class SpeechRecognitionHolder: NSObject, SFSpeechRecognizerDelegate {
    
    private static let tag = "SpeechRecognitionHolder"
    
    public weak var callback: OnSpeechRecognitionResultCallback?
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    public override init() {
        super.init()
        speechRecognizer?.delegate = self
    }
    
    public func forceSetLanguage() {
        // На iOS локаль задается при инициализации SFSpeechRecognizer(locale:)
    }
    
    public func initSpeechRecognition(stageViewController: UIViewController, stageResourceHolder: StageResourceHolder) {
        // Запрос разрешений на использование распознавания речи и микрофона
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("[\(SpeechRecognitionHolder.tag)] Speech recognition authorized.")
                    stageResourceHolder.resourceInitialized()
                case .denied, .restricted, .notDetermined:
                    print("[\(SpeechRecognitionHolder.tag)] Speech recognition not authorized.")
                    stageResourceHolder.resourceFailed(resourceName: "SpeechRecognition")
                @unknown default:
                    stageResourceHolder.resourceFailed(resourceName: "SpeechRecognition")
                }
            }
        }
    }
    
    public func startListening() {
        // Если уже идет распознавание — отменяем
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("[\(SpeechRecognitionHolder.tag)] Audio session setup failed: \(error.localizedDescription)")
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        guard let recognitionRequest = recognitionRequest else { return }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            var isFinal = false
            
            if let result = result {
                let spokenWords = result.bestTranscription.formattedString
                isFinal = result.isFinal
                
                if isFinal {
                    self?.callback?.onResult(spokenWords)
                    self?.stopListening()
                }
            }
            
            if error != nil || isFinal {
                self?.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self?.recognitionRequest = nil
                self?.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
            print("[\(SpeechRecognitionHolder.tag)] Started listening...")
        } catch {
            print("[\(SpeechRecognitionHolder.tag)] Audio engine failed to start: \(error.localizedDescription)")
        }
    }
    
    public func stopListening() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionRequest?.endAudio()
        }
    }
    
    public func destroy() {
        stopListening()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    
    // MARK: - SFSpeechRecognizerDelegate
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("[\(SpeechRecognitionHolder.tag)] Speech recognizer available.")
        } else {
            print("[\(SpeechRecognitionHolder.tag)] Speech recognizer unavailable.")
        }
    }
}
