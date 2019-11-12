#if os(iOS)
import XCTest
#endif

import ImageManagerTests

var tests = [XCTestCaseEntry]()
tests += ImageManagerTests.allTests()
XCTMain(tests)
