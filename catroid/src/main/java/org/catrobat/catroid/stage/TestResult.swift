import Foundation

public struct TestResult {
    public var message: String
    public var resultCode: Int
    
    public init(message: String, resultCode: Int) {
        self.message = message
        self.resultCode = resultCode
    }
    
    public static let stageActivityTestSuccess: Int = 7777
    public static let stageActivityTestFail: Int = 8888
    public static let testResultMessage: String = "ASSERTION_MESSAGE"
}
