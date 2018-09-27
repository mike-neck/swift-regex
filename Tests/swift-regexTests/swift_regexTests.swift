import XCTest
@testable import swift_regex

final class swift_regexTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_regex().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
