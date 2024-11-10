import UIKit

enum SAM2Error: Error {
    case invalidImage
    case processingFailed
    case invalidResponse
    case networkError(Error)
}

class SAM2Service {
    private let networkService: NetworkService
    private let runpodEndpoint = "https://api.runpod.ai/v2/sam2/run"
    private let apiKey: String
    private let storageService: LocalStorageService
    
    init(apiKey: String = ProcessInfo.processInfo.environment["SAM2_API_KEY"] ?? "",
         networkService: NetworkService = NetworkService(),
         storageService: LocalStorageService = LocalStorageService()) {
        self.apiKey = apiKey
        self.networkService = networkService
        self.storageService = storageService
    }
    
    struct SegmentationRequest: Codable {
        let input: Input
        
        struct Input: Codable {
            let image_url: String
            let prompt: String
        }
    }
    
    struct SegmentationResponse: Codable {
        let segmented_image: String
        let bbox: [Float]
    }
    
    func segmentCharacter(_ image: UIImage) async throws -> UIImage {
        // 1. Save image to temporary storage
        let imageUrl = try await uploadImage(image)
        
        // 2. Create segmentation request
        let request = SegmentationRequest(
            input: .init(
                image_url: imageUrl,
                prompt: "anime character"
            )
        )
        
        // 3. Process with SAM2
        let response: SegmentationResponse = try await networkService.post(
            url: runpodEndpoint,
            body: request,
            headers: ["Authorization": "Bearer \(apiKey)"]
        )
        
        // 4. Convert base64 response to image
        guard let imageData = Data(base64Encoded: response.segmented_image),
              let segmentedImage = UIImage(data: imageData) else {
            throw SAM2Error.invalidResponse
        }
        
        // 5. Cleanup temporary file
        storageService.cleanupTemporaryFiles()
        
        return segmentedImage
    }
    
    private func uploadImage(_ image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw SAM2Error.invalidImage
        }
        
        return try await storageService.uploadImage(imageData)
    }
} 