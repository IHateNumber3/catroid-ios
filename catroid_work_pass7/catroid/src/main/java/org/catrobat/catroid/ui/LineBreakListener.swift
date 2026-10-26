import Foundation

public protocol LineBreakListener: AnyObject {
    func setBreaks(_ breaks: [Int])
}
