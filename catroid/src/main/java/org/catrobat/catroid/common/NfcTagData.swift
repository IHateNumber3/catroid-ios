import Foundation

public final class NfcTagData: Nameable, Comparable, Hashable, CustomStringConvertible {

    public var name: String = ""
    public var nfcTagUid: String = ""

    public init() {}

    public func clone() -> NfcTagData {
        let c = NfcTagData()
        c.name = name
        c.nfcTagUid = nfcTagUid
        return c
    }

    public var description: String { return name }

    public static func == (l: NfcTagData, r: NfcTagData) -> Bool { return l.nfcTagUid == r.nfcTagUid }
    public static func < (l: NfcTagData, r: NfcTagData) -> Bool { return l.nfcTagUid < r.nfcTagUid }
    public func hash(into h: inout Hasher) { h.combine(name); h.combine(nfcTagUid) }
}
