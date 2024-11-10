import XCTest
import AWSS3
@testable import anime_character_identifier_app

class S3StorageServiceTests: XCTestCase {
    var sut: S3StorageService!
    
    override func setUp() {
        super.setUp()
        sut = S3StorageService(
            bucketName: "test-bucket",
            region: "us-east-1",
            accessKey: "test-key",
            secretKey: "test-secret"
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testUploadImage() async throws {
        // Given
        let testData = "test".data(using: .utf8)!
        let expectation = XCTestExpectation(description: "Upload completed")
        
        // Mock AWSS3TransferManager
        let mockTransferManager = MockAWSS3TransferManager()
        mockTransferManager.uploadResult = .success(())
        AWSS3TransferManager.mock = mockTransferManager
        
        // When
        let url = try await sut.uploadImage(testData)
        
        // Then
        XCTAssertTrue(url.contains("test-bucket.s3.us-east-1.amazonaws.com"))
        XCTAssertTrue(mockTransferManager.uploadWasCalled)
    }
}

// Mock AWS S3 Transfer Manager
class MockAWSS3TransferManager: AWSS3TransferManager {
    static var mock: MockAWSS3TransferManager?
    var uploadWasCalled = false
    var uploadResult: Result<Void, Error> = .success(())
    
    override func upload(_ uploadRequest: AWSS3TransferManagerUploadRequest) -> AWSTask<Any> {
        uploadWasCalled = true
        
        switch uploadResult {
        case .success:
            return AWSTask(result: nil)
        case .failure(let error):
            return AWSTask(error: error)
        }
    }
} 