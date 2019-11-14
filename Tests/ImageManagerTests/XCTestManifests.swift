import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ImageManagerTests.allTests),
        testCase(LocalURLHelperTests.allTests),
    ]
}
#endif
