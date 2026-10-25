import Foundation
import AVFoundation

public class UtteranceProgressListenerContainer {
    
    // Словарь для хранения списков слушателей по идентификатору речевого фрагмента
    private var listeners: [String: [UtteranceProgressListenerDelegate]] = [:]
    
    private let lockQueue = DispatchQueue(label: "org.catrobat.catroid.utteranceQueue", attributes: [.concurrent])
    
    /// Добавление слушателя прогресса для конкретного файла и ID
    @discardableResult
    public func addUtteranceProgressListener(
        speechFile: URL,
        utteranceProgressListener: UtteranceProgressListenerDelegate,
        utteranceId: String?
    ) -> Bool {
        guard let id = utteranceId else { return false }
        
        return lockQueue.sync(flags: .barrier) {
            if var utteranceIdListeners = listeners[id] {
                utteranceIdListeners.append(utteranceProgressListener)
                listeners[id] = utteranceIdListeners
                return false
            } else {
                if FileManager.default.fileExists(atPath: speechFile.path) {
                    utteranceProgressListener.onDone(utteranceId: id)
                    return false
                } else {
                    listeners[id] = [utteranceProgressListener]
                    return true
                }
            }
        }
    }
    
    /// Вызывается при успешном завершении речевого фрагмента
    public func onDone(utteranceId: String) {
        lockQueue.sync(flags: .barrier) {
            if let utteranceIdListeners = listeners[utteranceId] {
                for listener in utteranceIdListeners {
                    listener.onDone(utteranceId: utteranceId)
                }
                listeners.removeValue(forKey: utteranceId)
            }
        }
    }
    
    public func onStart(utteranceId: String) {
        lockQueue.sync(flags: .barrier) {
            if let utteranceIdListeners = listeners[utteranceId] {
                for listener in utteranceIdListeners {
                    listener.onStart(utteranceId: utteranceId)
                }
            }
        }
    }
    
    public func onError(utteranceId: String) {
        lockQueue.sync(flags: .barrier) {
            if let utteranceIdListeners = listeners[utteranceId] {
                for listener in utteranceIdListeners {
                    listener.onError(utteranceId: utteranceId)
                }
                listeners.removeValue(forKey: utteranceId)
            }
        }
    }
}
