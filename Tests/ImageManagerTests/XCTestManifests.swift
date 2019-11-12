#if os(iOS)
import XCTest
#endif

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ImageManagerTests.allTests),
    ]
}
#endif
