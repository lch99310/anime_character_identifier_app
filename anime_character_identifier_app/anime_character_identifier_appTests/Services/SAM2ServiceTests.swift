import XCTest
@testable import anime_character_identifier_app

class SAM2ServiceTests: XCTestCase {
    var sut: SAM2Service!
    var mockNetworkService: MockNetworkService!
    var mockStorageService: MockS3StorageService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockStorageService = MockS3StorageService()
        sut = SAM2Service(
            apiKey: "test-key",
            networkService: mockNetworkService,
            storageService: mockStorageService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockStorageService = nil
        super.tearDown()
    }
    
    func testSegmentCharacter() async throws {
        // Given
        let testImage = UIImage()
        let expectedUrl = "https://test-bucket.s3.amazonaws.com/test.jpg"
        mockStorageService.nextUploadUrl = expectedUrl
        
        let expectedResponse = SAM2Service.SegmentationResponse(
            segmented_image: "base64_encoded_image",
            bbox: [0, 0, 100, 100]
        )
        mockNetworkService.nextResponse = expectedResponse
        
        // When
        _ = try await sut.segmentCharacter(testImage)
        
        // Then
        XCTAssertTrue(mockStorageService.uploadWasCalled)
        XCTAssertTrue(mockNetworkService.postWasCalled)
        XCTAssertEqual(mockNetworkService.lastUrl, "https://api.runpod.ai/v2/sam2/run")
    }
}

// Mock Network Service
class MockNetworkService: NetworkService {
    var postWasCalled = false
    var lastUrl: String?
    var nextResponse: Any?
    var nextError: Error?
    
    override func post<T, U>(
        url: String,
        body: T,
        headers: [String : String] = [:]
    ) async throws -> U where T : Encodable, U : Decodable {
        postWasCalled = true
        lastUrl = url
        
        if let error = nextError {
            throw error
        }
        
        return nextResponse as! U
    }
}

// Mock S3 Storage Service
class MockS3StorageService: S3StorageService {
    var uploadWasCalled = false
    var nextUploadUrl: String?
    var nextError: Error?
    
    override func uploadImage(_ imageData: Data) async throws -> String {
        uploadWasCalled = true
        
        if let error = nextError {
            throw error
        }
        
        return nextUploadUrl ?? "https://test-url.com"
    }
} 