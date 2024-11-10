import XCTest
@testable import anime_character_identifier_app

class ServiceCoordinatorTests: XCTestCase {
    var sut: ServiceCoordinator!
    var mockSAM2Service: MockSAM2Service!
    var mockLlama3Service: MockLlama3Service!
    var mockACDBService: MockACDBService!
    var mockYouTubeService: MockYouTubeService!
    
    override func setUp() {
        super.setUp()
        mockSAM2Service = MockSAM2Service()
        mockLlama3Service = MockLlama3Service()
        mockACDBService = MockACDBService()
        mockYouTubeService = MockYouTubeService()
        
        sut = ServiceCoordinator(
            sam2Service: mockSAM2Service,
            llama3Service: mockLlama3Service,
            acdbService: mockACDBService,
            youtubeService: mockYouTubeService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockSAM2Service = nil
        mockLlama3Service = nil
        mockACDBService = nil
        mockYouTubeService = nil
        super.tearDown()
    }
    
    func testProcessImageSuccess() async throws {
        // Given
        let testImage = UIImage()
        let expectedCharacter = CharacterDetails(
            id: 1,
            name: "Naruto",
            animeName: "Naruto",
            description: "Test description",
            imageUrl: "https://example.com/naruto.jpg"
        )
        let expectedVideos = [
            VideoResult(
                videoId: "123",
                title: "Naruto vs Sasuke",
                thumbnailUrl: "https://example.com/thumbnail.jpg",
                description: "Epic battle"
            )
        ]
        
        mockSAM2Service.nextSegmentedImage = UIImage()
        mockLlama3Service.nextIdentification = CharacterIdentification(
            name: "Naruto",
            animeName: "Naruto",
            confidence: 0.95
        )
        mockACDBService.nextCharacterDetails = expectedCharacter
        mockYouTubeService.nextVideos = expectedVideos
        
        // When
        let (character, videos) = try await sut.processImage(testImage)
        
        // Then
        XCTAssertTrue(mockSAM2Service.segmentCharacterCalled)
        XCTAssertTrue(mockLlama3Service.identifyCharacterCalled)
        XCTAssertTrue(mockACDBService.getCharacterInfoCalled)
        XCTAssertTrue(mockYouTubeService.searchVideosCalled)
        
        XCTAssertEqual(character.name, expectedCharacter.name)
        XCTAssertEqual(videos.first?.videoId, expectedVideos.first?.videoId)
    }
}

// Mock Services
class MockSAM2Service: SAM2Service {
    var segmentCharacterCalled = false
    var nextSegmentedImage: UIImage?
    var nextError: Error?
    
    override func segmentCharacter(_ image: UIImage) async throws -> UIImage {
        segmentCharacterCalled = true
        if let error = nextError { throw error }
        return nextSegmentedImage ?? UIImage()
    }
}

class MockLlama3Service: Llama3Service {
    var identifyCharacterCalled = false
    var nextIdentification: CharacterIdentification?
    var nextError: Error?
    
    override func identifyCharacter(_ image: UIImage) async throws -> CharacterIdentification {
        identifyCharacterCalled = true
        if let error = nextError { throw error }
        return nextIdentification ?? CharacterIdentification(name: "", animeName: "", confidence: 0)
    }
}

class MockACDBService: ACDBService {
    var getCharacterInfoCalled = false
    var nextCharacterDetails: CharacterDetails?
    var nextError: Error?
    
    override func getCharacterInfo(_ name: String) async throws -> CharacterDetails {
        getCharacterInfoCalled = true
        if let error = nextError { throw error }
        return nextCharacterDetails ?? CharacterDetails(id: 0, name: "", animeName: "", description: "", imageUrl: "")
    }
}

class MockYouTubeService: YouTubeService {
    var searchVideosCalled = false
    var nextVideos: [VideoResult]?
    var nextError: Error?
    
    override func searchVideos(character: String, anime: String) async throws -> [VideoResult] {
        searchVideosCalled = true
        if let error = nextError { throw error }
        return nextVideos ?? []
    }
} 