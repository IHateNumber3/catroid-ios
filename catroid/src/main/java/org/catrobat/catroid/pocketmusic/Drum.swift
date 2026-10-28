import Foundation

/// MIDI percussion selection used by legacy drum bricks.
public enum Drum: Int, CaseIterable {
    case bassDrum = 0
    case sideStick = 1
    case snare = 2
    case handClap = 3
    case electricSnare = 4
    case lowFloorTom = 5
    case closedHiHat = 6
    case highFloorTom = 7
    case pedalHiHat = 8
    case lowTom = 9
    case openHiHat = 10
    case lowMidTom = 11
    case highMidTom = 12
    case crashCymbal = 13
    case highTom = 14
    case rideCymbal = 15

    public static func getDrumFromProgram(_ program: Int) -> Drum {
        return Drum(rawValue: min(max(program, 0), 15)) ?? .bassDrum
    }
}
