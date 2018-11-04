import XCTest
import SwiftRegex
@testable import POSIXRegex

final class POSIXRegexTests: XCTestCase {

    typealias XCTestCaseEntry = (String, (POSIXRegexTests) -> () -> ())

    static var allTests: [XCTestCaseEntry] = [
        ("testRegexUsage", testRegexUsage),
        ("testRegexUsageNotMatch", testRegexUsageNotMatch),
    ]

    func testRegexUsage() {
        SwiftRegexImplementation.by.usePosix()
        guard let swiftRegex = pattern(of: "ba").compile() else {
            XCTFail("compiling pattern[\"ba\"] failed.")
            return
        }

        let matcher: RegexMatcher = swiftRegex.matcher(for: "foo-bar-baz")
        XCTAssertTrue(matcher.matches)
    }

    func testRegexUsageNotMatch() {
        SwiftRegexImplementation.by.usePosix()
        guard let swiftRegex = pattern(of: "ba").compile() else {
            XCTFail("compiling pattern[\"ba\"] failed.")
            return
        }

        let matcher = swiftRegex.matcher(for: "foo")
        XCTAssertFalse(matcher.matches)
    }
}
