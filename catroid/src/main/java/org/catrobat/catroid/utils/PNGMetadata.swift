import Foundation

/// Чтение/запись tEXt-чанков PNG (замена PNGJ в ImageEditing).
enum PNGMetadata {

    private static let signature: [UInt8] = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A]

    private static let crcTable: [UInt32] = (0..<256).map { n -> UInt32 in
        var c = UInt32(n)
        for _ in 0..<8 { c = (c & 1) != 0 ? (0xEDB88320 ^ (c >> 1)) : (c >> 1) }
        return c
    }

    private static func crc32(_ bytes: [UInt8]) -> UInt32 {
        var c: UInt32 = 0xFFFFFFFF
        for b in bytes { c = crcTable[Int((c ^ UInt32(b)) & 0xFF)] ^ (c >> 8) }
        return c ^ 0xFFFFFFFF
    }

    private struct Chunk { let type: String; let data: [UInt8] }

    private static func parse(_ data: Data) -> [Chunk]? {
        let bytes = [UInt8](data)
        guard bytes.count > 8, Array(bytes[0..<8]) == signature else { return nil }
        var pos = 8
        var chunks: [Chunk] = []
        while pos + 12 <= bytes.count {
            let len = Int(bytes[pos]) << 24 | Int(bytes[pos + 1]) << 16 | Int(bytes[pos + 2]) << 8 | Int(bytes[pos + 3])
            let type = String(bytes: bytes[(pos + 4)..<(pos + 8)], encoding: .ascii) ?? ""
            let end = pos + 8 + len
            guard end + 4 <= bytes.count else { return nil }
            chunks.append(Chunk(type: type, data: Array(bytes[(pos + 8)..<end])))
            pos = end + 4
            if type == "IEND" { break }
        }
        return chunks
    }

    /// nil — файл не читается/не PNG (в Java: PngjInputException)
    static func readText(path: String, key: String) -> String? {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)), let chunks = parse(data) else { return nil }
        for c in chunks where c.type == "tEXt" {
            if let zero = c.data.firstIndex(of: 0) {
                let k = String(bytes: c.data[0..<zero], encoding: .isoLatin1) ?? ""
                if k == key { return String(bytes: c.data[(zero + 1)...], encoding: .isoLatin1) ?? "" }
            }
        }
        return ""
    }

    private static func encode(_ chunk: Chunk) -> [UInt8] {
        let typeBytes = Array(chunk.type.utf8)
        var out: [UInt8] = []
        let n = UInt32(chunk.data.count)
        out += [UInt8(n >> 24), UInt8((n >> 16) & 0xFF), UInt8((n >> 8) & 0xFF), UInt8(n & 0xFF)]
        out += typeBytes
        out += chunk.data
        let crc = crc32(typeBytes + chunk.data)
        out += [UInt8(crc >> 24), UInt8((crc >> 16) & 0xFF), UInt8((crc >> 8) & 0xFF), UInt8(crc & 0xFF)]
        return out
    }

    @discardableResult
    static func writeText(path: String, key: String, value: String) -> Bool {
        let url = URL(fileURLWithPath: path)
        guard let data = try? Data(contentsOf: url), var chunks = parse(data) else { return false }
        chunks.removeAll { c in
            guard c.type == "tEXt", let zero = c.data.firstIndex(of: 0) else { return false }
            return String(bytes: c.data[0..<zero], encoding: .isoLatin1) == key
        }
        var payload = Array(key.data(using: .isoLatin1) ?? Data())
        payload.append(0)
        payload += Array(value.data(using: .isoLatin1) ?? Data())
        let textChunk = Chunk(type: "tEXt", data: payload)
        let iendIndex = chunks.lastIndex { $0.type == "IEND" } ?? chunks.count
        chunks.insert(textChunk, at: iendIndex)

        var out = signature
        for c in chunks { out += encode(c) }
        let tmp = url.deletingPathExtension().appendingPathExtension("___temp.png")
        do {
            try Data(out).write(to: tmp)
            _ = try FileManager.default.replaceItemAt(url, withItemAt: tmp)
            return true
        } catch {
            try? FileManager.default.removeItem(at: tmp)
            return false
        }
    }
}
