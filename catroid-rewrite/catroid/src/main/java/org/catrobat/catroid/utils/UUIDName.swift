import Foundation
import CryptoKit

public extension UUID {
    /// java.util.UUID.nameUUIDFromBytes: версия 3 (MD5)
    static func nameUUIDFromBytes(_ data: Data) -> UUID {
        var md5 = Array(Insecure.MD5.hash(data: data))
        md5[6] = (md5[6] & 0x0f) | 0x30
        md5[8] = (md5[8] & 0x3f) | 0x80
        return UUID(uuid: (md5[0], md5[1], md5[2], md5[3], md5[4], md5[5], md5[6], md5[7],
                           md5[8], md5[9], md5[10], md5[11], md5[12], md5[13], md5[14], md5[15]))
    }
}
