import Foundation

/// iOS compatibility provider. Hardware sensors are unavailable until native
/// CoreMotion/location adapters are connected.
public enum SensorHandler {
    public static func getSensorValue(_ sensor: Sensors) -> Double {
        switch sensor {
        case .userLanguage: return 0
        default: return 0
        }
    }
}
