import Foundation

public enum StageResourceError: Error {
    case mindstormsError(message: String)
}

public protocol StageResourceProtocol: AnyObject {
    /// Инициализация ресурса или сервиса
    func initialise() throws
    
    /// Запуск работы ресурса
    func start() throws
    
    /// Приостановка работы
    func pause()
    
    /// Полное уничтожение / освобождение ресурсов
    func destroy()
}
