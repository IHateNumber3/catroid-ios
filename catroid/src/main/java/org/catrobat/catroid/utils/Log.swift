import Foundation
import os

/// Замена android.util.Log
public enum Log {
    private static let logger = Logger(subsystem: "org.catrobat.catroid", category: "app")
    public static func d(_ tag: String, _ msg: String, _ e: Error? = nil) {
        logger.debug("[\(tag)] \(msg) \(e.map { String(describing: $0) } ?? "")")
    }
    public static func i(_ tag: String, _ msg: String, _ e: Error? = nil) {
        logger.info("[\(tag)] \(msg) \(e.map { String(describing: $0) } ?? "")")
    }
    public static func w(_ tag: String, _ msg: String, _ e: Error? = nil) {
        logger.warning("[\(tag)] \(msg) \(e.map { String(describing: $0) } ?? "")")
    }
    public static func e(_ tag: String, _ msg: String, _ e: Error? = nil) {
        logger.error("[\(tag)] \(msg) \(e.map { String(describing: $0) } ?? "")")
    }
}
