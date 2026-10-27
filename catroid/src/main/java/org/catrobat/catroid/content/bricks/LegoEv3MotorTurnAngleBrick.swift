import Foundation

/// Swift-side compatibility declaration for the EV3 motor turn-angle brick.
/// The Android Java brick is not compiled into the iOS target, but ActionFactory
/// still uses its nested Motor type to preserve the original API.
public enum LegoEv3MotorTurnAngleBrick {
    public enum Motor: String, CaseIterable {
        case MOTOR_A
        case MOTOR_B
        case MOTOR_C
        case MOTOR_D
        case MOTOR_B_C
        case MOTOR_ALL
    }
}
