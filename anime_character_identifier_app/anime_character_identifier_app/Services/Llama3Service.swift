import UIKit

enum Llama3Error: Error {
    case invalidImage
    case processingFailed
    case invalidResponse
    case networkError(Error)
}

class Llama3Service {
    private let networkService: NetworkService
    private let endpoint = "https://api.replicate.com/v1/predictions"
    private let apiKey: String
    
    init(apiKey: String = ProcessInfo.processInfo.environment["LLAMA3_API_KEY"] ?? "",
         networkService: NetworkService = NetworkService()) {
        self.apiKey = apiKey
        self.networkService = networkService
    }
    
    struct IdentificationRequest: Codable {
        let version: String = "2b017d9b67edd2ee1b0b7389e2105ed693d949ea9f7321cab24871e5b79ee3b4"
        let input: Input
        
        struct Input: Codable {
            let image: String
            let prompt: String
            let temperature: Float
            let max_tokens: Int
        }
    }
    
    struct IdentificationResponse: Codable {
        let output: String
    }
    
    func identifyCharacter(_ image: UIImage) async throws -> CharacterIdentification {
        guard let base64Image = image.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            throw Llama3Error.invalidImage
        }
        
        let request = IdentificationRequest(
            input: .init(
                image: base64Image,
                prompt: "Identify the anime character in this image. Respond in JSON format with fields: name, animeName, confidence",
                temperature: 0.7,
                max_tokens: 100
            )
        )
        
        let response: IdentificationResponse = try await networkService.post(
            url: endpoint,
            body: request,
            headers: ["Authorization": "Bearer \(apiKey)"]
        )
        
        // Parse the JSON response
        let decoder = JSONDecoder()
        guard let data = response.output.data(using: .utf8),
              let identification = try? decoder.decode(CharacterIdentification.self, from: data) else {
            throw Llama3Error.invalidResponse
        }
        
        return identification
    }
} 