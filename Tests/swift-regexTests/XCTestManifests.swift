import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(swift_regexTests.allTests),
    ]
}
#endif