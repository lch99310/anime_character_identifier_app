import XCTest
@testable import anime_character_identifier_app

class ACDBServiceTests: XCTestCase {
    var sut: ACDBService!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = ACDBService(apiKey: "test-key", networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testGetCharacterInfo() async throws {
        // Given
        let expectedResponse = ACDBService.SearchResponse(characters: [
            .init(
                id: 1,
                name: "Naruto Uzumaki",
                anime: "Naruto",
                description: "A ninja who wants to become Hokage",
                image_url: "https://example.com/naruto.jpg"
            )
        ])
        mockNetworkService.nextResponse = expectedResponse
        
        // When
        let result = try await sut.getCharacterInfo("Naruto")
        
        // Then
        XCTAssertTrue(mockNetworkService.postWasCalled)
        XCTAssertEqual(mockNetworkService.lastUrl, "https://www.animecharactersdatabase.com/api/character/search")
        XCTAssertEqual(result.name, "Naruto Uzumaki")
        XCTAssertEqual(result.animeName, "Naruto")
    }
    
    func testGetCharacterInfoNotFound() async {
        // Given
        let emptyResponse = ACDBService.SearchResponse(characters: [])
        mockNetworkService.nextResponse = emptyResponse
        
        // When/Then
        do {
            _ = try await sut.getCharacterInfo("NonexistentCharacter")
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertTrue(error is ACDBError)
            XCTAssertEqual(error as? ACDBError, .characterNotFound)
        }
    }
} 