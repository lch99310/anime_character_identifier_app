import Foundation
import UIKit

class ServiceCoordinator {
    private let sam2Service: SAM2Service
    private let llama3Service: Llama3Service
    private let acdbService: ACDBService
    private let youtubeService: YouTubeService
    
    init(sam2Service: SAM2Service = SAM2Service(),
         llama3Service: Llama3Service = Llama3Service(),
         acdbService: ACDBService = ACDBService(),
         youtubeService: YouTubeService = YouTubeService()) {
        self.sam2Service = sam2Service
        self.llama3Service = llama3Service
        self.acdbService = acdbService
        self.youtubeService = youtubeService
    }
    
    func processImage(_ image: UIImage) async throws -> (CharacterDetails, [VideoResult]) {
        // 1. Segment character
        let segmentedImage = try await sam2Service.segmentCharacter(image)
        
        // 2. Identify character
        let identification = try await llama3Service.identifyCharacter(segmentedImage)
        
        // 3. Get character details
        let characterDetails = try await acdbService.getCharacterInfo(identification.name)
        
        // 4. Get related videos
        let videos = try await youtubeService.searchVideos(
            character: identification.name,
            anime: identification.animeName
        )
        
        return (characterDetails, videos)
    }
    
    static var shared = ServiceCoordinator()
} 