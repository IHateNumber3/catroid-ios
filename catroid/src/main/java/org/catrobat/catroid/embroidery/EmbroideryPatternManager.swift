import Foundation
import UIKit

/// Collected stitch points shared by the stage renderer and DST exporter.
public final class EmbroideryPatternManager {
    public static let shared = EmbroideryPatternManager()
    private let lock = NSRecursiveLock()
    private var points: [EmbroideryStitchPoint] = []
    private init() {}

    public func addPoint(x: Float, y: Float, jump: Bool = false, colorChange: Bool = false) {
        lock.lock(); defer { lock.unlock() }
        let point = EmbroideryStitchPoint(x: x, y: y, isJumpPoint: jump, isColorChangePoint: colorChange)
        if let previous = points.last {
            let dx = Int((x * 2).rounded()) - Int((previous.x * 2).rounded())
            let dy = Int((y * 2).rounded()) - Int((previous.y * 2).rounded())
            let distance = max(abs(dx), abs(dy))
            if distance > 121 {
                let count = Int(ceil(Double(distance) / 121.0))
                for step in 1..<count {
                    let t = Float(step) / Float(count)
                    points.append(EmbroideryStitchPoint(x: previous.x + (x - previous.x) * t,
                                                        y: previous.y + (y - previous.y) * t,
                                                        isJumpPoint: true, isColorChangePoint: false))
                }
            }
        }
        points.append(point)
    }

    public func getEmbroideryPatternList() -> [EmbroideryStitchPoint] { lock.lock(); defer { lock.unlock() }; return points }
    public func validPatternExists() -> Bool { lock.lock(); defer { lock.unlock() }; return points.count > 1 }
    public func clear() { lock.lock(); defer { lock.unlock() }; points.removeAll() }

    public func writeDST(to url: URL, label: String = "Catroid") throws {
        lock.lock(); let snapshot = points; lock.unlock()
        guard snapshot.count > 1 else { throw NSError(domain: "CatroidEmbroidery", code: 1, userInfo: [NSLocalizedDescriptionKey: "No embroidery pattern has been recorded."]) }
        let units = snapshot.map { (x: Int(($0.x * 2).rounded()), y: Int(($0.y * 2).rounded()), point: $0) }
        let xs = units.map(\.x), ys = units.map(\.y)
        let first = units[0], last = units[units.count - 1]
        let changes = max(1, 1 + snapshot.filter(\.isColorChangePoint).count)
        var header = "LA:\(String(label.prefix(15)).padding(toLength: 15, withPad: " ", startingAt: 0))\n\u{001A}"
        func field(_ key: String, _ value: Int, _ width: Int) -> String { "\(key):\(String(value).padding(toLength: width, withPad: " ", startingAt: 0))\n\u{001A}" }
        header += field("ST", units.count, 6)
        header += field("CO", changes, 2)
        header += field("+X", max(0, xs.max() ?? 0), 4)
        header += field("-X", abs(min(0, xs.min() ?? 0)), 4)
        header += field("+Y", max(0, ys.max() ?? 0), 4)
        header += field("-Y", abs(min(0, ys.min() ?? 0)), 4)
        header += field("AX", last.x - first.x, 5)
        header += field("AY", last.y - first.y, 5)
        header += field("MX", 0, 5) + field("MY", 0, 5) + "PD:*****\n\u{001A}"
        var output = Data(header.utf8)
        if output.count < 512 { output.append(Data(repeating: 0x20, count: 512 - output.count)) }
        if output.count > 512 { output = output.prefix(512) }
        var previousX = first.x, previousY = first.y
        for (index, item) in units.enumerated() {
            let dx = item.x - previousX, dy = item.y - previousY
            let bytes = Self.encode(dx: dx, dy: dy, jump: item.point.isJumpPoint, colorChange: item.point.isColorChangePoint)
            output.append(contentsOf: bytes)
            previousX = item.x; previousY = item.y
            if index == 0 && dx == 0 && dy == 0 { continue }
        }
        output.append(contentsOf: [0x00, 0x00, 0xF3])
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try output.write(to: url, options: .atomic)
    }

    private static let conversionTable: [Int] = [0, 1, 6, 4, 5, 26, 24, 25, 18, 16, 17, 22, 20, 21, 106, 104, 105, 98, 96, 97, 102, 100, 101, 74, 72, 73, 66, 64, 65, 70, 68, 69, 90, 88, 89, 82, 80, 81, 86, 84, 85, 426, 424, 425, 418, 416, 417, 422, 420, 421, 394, 392, 393, 386, 384, 385, 390, 388, 389, 410, 408, 409, 402, 400, 401, 406, 404, 405, 298, 296, 297, 290, 288, 289, 294, 292, 293, 266, 264, 265, 258, 256, 257, 262, 260, 261, 282, 280, 281, 274, 272, 273, 278, 276, 277, 362, 360, 361, 354, 352, 353, 358, 356, 357, 330, 328, 329, 322, 320, 321, 326, 324, 325, 346, 344, 345, 338, 336, 337, 342, 340, 341, 2, 9, 8, 10, 37, 36, 38, 33, 32, 34, 41, 40, 42, 149, 148, 150, 145, 144, 146, 153, 152, 154, 133, 132, 134, 129, 128, 130, 137, 136, 138, 165, 164, 166, 161, 160, 162, 169, 168, 170, 597, 596, 598, 593, 592, 594, 601, 600, 602, 581, 580, 582, 577, 576, 578, 585, 584, 586, 613, 612, 614, 609, 608, 610, 617, 616, 618, 533, 532, 534, 529, 528, 530, 537, 536, 538, 517, 516, 518, 513, 512, 514, 521, 520, 522, 549, 548, 550, 545, 544, 546, 553, 552, 554, 661, 660, 662, 657, 656, 658, 665, 664, 666, 645, 644, 646, 641, 640, 642, 649, 648, 650, 677, 676, 678, 673, 672, 674, 681, 680, 682]
    private static func encode(dx: Int, dy: Int, jump: Bool, colorChange: Bool) -> [UInt8] {
        func map(_ value: Int) -> Int {
            let clamped = max(-121, min(121, value))
            let index = clamped < 0 ? abs(clamped) + 121 : clamped
            return conversionTable[index]
        }
        let x = map(dx), y = map(dy)
        var b0 = ((((y & 0x1) << 3) | ((y & 0x2) << 1) | ((y & 0x10) >> 3) | ((y & 0x20) >> 5)) << 4)
        b0 |= ((x >> 2) & 0xC) | (x & 0x3)
        var b1 = ((((y & 0x4) << 1) | ((y & 0x8) >> 1) | ((y & 0x40) >> 5) | ((y & 0x80) >> 7)) << 4)
        b1 |= ((x >> 4) & 0xC) | ((x >> 2) & 0x3)
        var b2 = 0x03 | ((y >> 5) & 0x10) | ((y >> 3) & 0x20) | ((x >> 6) & 0x0C)
        if jump { b2 |= 0x80 }
        if colorChange { b2 |= 0xC0 }
        return [UInt8(b0 & 0xFF), UInt8(b1 & 0xFF), UInt8(b2 & 0xFF)]
    }
}

public final class EmbroideryStitchPoint {
    public let x: Float
    public let y: Float
    public let isJumpPoint: Bool
    public let isColorChangePoint: Bool
    public var isConnectingPoint: Bool { !isJumpPoint && !isColorChangePoint }
    public init(x: Float, y: Float, isJumpPoint: Bool = false, isColorChangePoint: Bool = false) {
        self.x = x; self.y = y; self.isJumpPoint = isJumpPoint; self.isColorChangePoint = isColorChangePoint
    }
}
