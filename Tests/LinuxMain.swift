import XCTest

import swift_regexTests

var tests = [XCTestCaseEntry]()
tests += POSIXRegexTests.allTests()
XCTMain(tests)
