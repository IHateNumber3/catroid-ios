import Foundation

public class BaseExceptionHandler {
    
    private static let tag = "BaseExceptionHandler"
    private static let recoveredFromCrashKey = "RECOVERED_FROM_CRASH"
    
    /// Установка глобального перехватчика необработанных исключений в iOS
    public static func setup() {
        NSSetUncaughtExceptionHandler { exception in
            let stackTrace = exception.callStackSymbols
            print("[\(tag)] Uncaught exception: \(exception.name.rawValue) - \(exception.reason ?? "Unknown reason")")
            print("[\(tag)] Stack trace: \(stackTrace)")
            
            // Сохранение флага восстановления после краша (аналог SharedPreferences)
            UserDefaults.standard.set(true, forKey: recoveredFromCrashKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// Принудительный выход из приложения (аналог exit())
    public static func exitApp() {
        print("[\(tag)] Exiting application due to critical error.")
        exit(10) // Эквивалент EXIT_CODE = 10
    }
}
