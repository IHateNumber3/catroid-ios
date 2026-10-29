import Foundation

public enum PickableMusicalInstrument: Int, CaseIterable {
    case piano = 0
    case electricPiano = 2
    case cello = 42
    case flute = 73
    case vibraphone = 11
    case organ = 16
    case guitar = 24
    case electricGuitar = 26
    case bass = 32
    case pizzicato = 45
    case synthPad = 90
    case choir = 52
    case synthLead = 80
    case woodenFlute = 75
    case trombone = 57
    case saxophone = 64
    case bassoon = 70
    case clarinet = 71
    case musicBox = 10
    case steelDrum = 114
    case marimba = 12

    public var value: Int { return rawValue }
    public func getValue() -> Int { return rawValue }

    private var stringKey: String {
        switch self {
        case .piano: return "piano"
        case .electricPiano: return "electric_piano"
        case .cello: return "cello"
        case .flute: return "flute"
        case .vibraphone: return "vibraphone"
        case .organ: return "organ"
        case .guitar: return "guitar"
        case .electricGuitar: return "electric_guitar"
        case .bass: return "bass"
        case .pizzicato: return "pizzicato"
        case .synthPad: return "synth_pad"
        case .choir: return "choir"
        case .synthLead: return "synth_lead"
        case .woodenFlute: return "wooden_flute"
        case .trombone: return "trombone"
        case .saxophone: return "saxophone"
        case .bassoon: return "bassoon"
        case .clarinet: return "clarinet"
        case .musicBox: return "music_box"
        case .steelDrum: return "steel_drum"
        case .marimba: return "marimba"
        }
    }

    public var displayName: String {
        return NSLocalizedString(stringKey, value: stringKey, comment: "")
    }

    public static func getIndexByValue(_ value: Int) -> Int {
        return allCases.firstIndex { $0.rawValue == value } ?? -1
    }
}
