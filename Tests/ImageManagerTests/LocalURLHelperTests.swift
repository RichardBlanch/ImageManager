import XCTest
@testable import ImageManager


final class LocalURLHelperTests: XCTestCase {
    private var hasher: URLHash!
    private var directoryToSave: URL!
    private var localURLHelper: LocalURLHelper!
    
    override func setUp() {
        super.setUp()
        
        
        hasher = SHA256KeepingLowerCaseLettersHash()
        directoryToSave = ImageManager.cachedImageDirectory()
        localURLHelper = LocalURLHelper(fileManager: FileManager.default,
                                        directoryToSave: ImageManager.cachedImageDirectory(),
                                        hasher: hasher)
    }
    
    override func tearDown() {
        super.tearDown()
        
        hasher = nil
        directoryToSave = nil
        localURLHelper = nil
        
        try! FileManager.default.removeItem(at: directoryToSave)
    }
    
    func testImageDirectoryExists() {
        XCTAssertNotNil(directoryToSave)
    }
    
    static var allTests = [
        ("testExample", testImageDirectoryExists),
    ]
}

