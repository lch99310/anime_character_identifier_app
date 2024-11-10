import XCTest
@testable import anime_character_identifier_app

class Llama3ServiceTests: XCTestCase {
    var sut: Llama3Service!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = Llama3Service(apiKey: "test-key", networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testIdentifyCharacter() async throws {
        // Given
        let testImage = UIImage()
        let expectedResponse = Llama3Service.IdentificationResponse(
            output: """
            {
                "name": "Naruto Uzumaki",
                "animeName": "Naruto",
                "confidence": 0.95
            }
            """
        )
        mockNetworkService.nextResponse = expectedResponse
        
        // When
        let result = try await sut.identifyCharacter(testImage)
        
        // Then
        XCTAssertTrue(mockNetworkService.postWasCalled)
        XCTAssertEqual(mockNetworkService.lastUrl, "https://api.replicate.com/v1/predictions")
        XCTAssertEqual(result.name, "Naruto Uzumaki")
        XCTAssertEqual(result.animeName, "Naruto")
        XCTAssertEqual(result.confidence, 0.95)
    }
    
    func testIdentifyCharacterInvalidResponse() async {
        // Given
        let testImage = UIImage()
        let invalidResponse = Llama3Service.IdentificationResponse(output: "invalid json")
        mockNetworkService.nextResponse = invalidResponse
        
        // When/Then
        do {
            _ = try await sut.identifyCharacter(testImage)
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is Llama3Error)
            XCTAssertEqual(error as? Llama3Error, .invalidResponse)
        }
    }
} 