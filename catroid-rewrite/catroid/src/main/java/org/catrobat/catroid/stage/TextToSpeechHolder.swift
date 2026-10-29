import Foundation
import AVFoundation
import UIKit

public class TextToSpeechHolder: NSObject, AVSpeechSynthesizerDelegate {
    
    private static let tag = "TextToSpeechHolder"
    
    private var synthesizer: AVSpeechSynthesizer?
    // Хранилище делегатов или слушателей прогресса речевых фрагментов
    // private var progressListenerContainer: UtteranceProgressListenerContainer?
    
    public static let shared = TextToSpeechHolder()
    
    private override init() {
        super.init()
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer?.delegate = self
    }
    
    /// Инициализация синтезатора речи (на iOS встроен в систему)
    public func initTextToSpeech(stageViewController: UIViewController, stageResourceHolder: StageResourceHolder) {
        // В iOS движок Text-to-Speech доступен всегда по умолчанию
        print("[\(TextToSpeechHolder.tag)] TextToSpeech initialized successfully.")
        stageResourceHolder.resourceInitialized()
    }
    
    /// Остановка и выключение синтезатора
    public func shutDownTextToSpeech() {
        synthesizer?.stopSpeaking(at: .immediate)
        synthesizer = nil
    }
    
    /// Синтез текста в файл или озвучивание (на iOS 13+ доступна запись в аудиофайлы)
    public func textToSpeech(text: String?, speechFile: URL, speakParameters: [String: String?]) {
        guard let text = text, !text.isEmpty else { return }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())
        
        // В современных версиях iOS синтез в файл делается через write(_:toBufferCallback:)
        if #available(iOS 13.0, *) {
            synthesizer?.write(utterance) { [weak self] (audioBuffer) in
                guard let pcmBuffer = audioBuffer as? AVAudioPCMBuffer else { return }
                // Здесь можно сохранить буфер в файл через AVAudioFile, если требуется для игровых блоков Catroid
                self?.savePCMBuffer(pcmBuffer, to: speechFile)
            }
        } else {
            // Для старых версий просто проговариваем в реальном времени
            synthesizer?.speak(utterance)
        }
    }
    
    private func savePCMBuffer(_ buffer: AVAudioPCMBuffer, to url: URL) {
        // Логика записи AVAudioPCMBuffer в файл (при необходимости)
        do {
            let file = try AVAudioFile(forWriting: url, settings: buffer.format.settings)
            try file.write(from: buffer)
        } catch {
            print("[\(TextToSpeechHolder.tag)] Failed to write TTS audio file: \(error.localizedDescription)")
        }
    }
    
    /// Удаление временных речевых файлов
    public func deleteSpeechFiles() {
        let tmpDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("TextToSpeech_Tmp", isDirectory: true)
        
        do {
            if FileManager.default.fileExists(atPath: tmpDirectory.path) {
                let files = try FileManager.default.contentsOfDirectory(at: tmpDirectory, includingPropertiesForKeys: nil)
                for file in files {
                    try FileManager.default.removeItem(at: file)
                }
            }
        } catch {
            print("[\(TextToSpeechHolder.tag)] Error deleting speech files: \(error.localizedDescription)")
        }
    }
    
    // MARK: - AVSpeechSynthesizerDelegate
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("[\(TextToSpeechHolder.tag)] Started speaking: \(utterance.speechString)")
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("[\(TextToSpeechHolder.tag)] Finished speaking: \(utterance.speechString)")
    }
}
