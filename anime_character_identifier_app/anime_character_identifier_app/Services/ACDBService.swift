import Foundation

enum ACDBError: Error {
    case invalidResponse
    case characterNotFound
    case networkError(Error)
    case rateLimitExceeded
}

class ACDBService {
    private let networkService: NetworkService
    private let baseURL = "https://www.animecharactersdatabase.com/api"
    private let apiKey: String
    private let rateLimiter: RateLimiter
    
    init(apiKey: String = ProcessInfo.processInfo.environment["ACDB_API_KEY"] ?? "",
         networkService: NetworkService = NetworkService()) {
        self.apiKey = apiKey
        self.networkService = networkService
        self.rateLimiter = RateLimiter(requestsPerSecond: 2)
    }
    
    struct SearchRequest: Codable {
        let name: String
        let limit: Int
    }
    
    struct SearchResponse: Codable {
        let characters: [Character]
        
        struct Character: Codable {
            let id: Int
            let name: String
            let anime: String
            let description: String?
            let image_url: String
        }
    }
    
    func getCharacterInfo(_ name: String) async throws -> CharacterDetails {
        try await rateLimiter.execute {
            let request = SearchRequest(name: name, limit: 1)
            
            let response: SearchResponse = try await networkService.post(
                url: "\(baseURL)/character/search",
                body: request,
                headers: ["X-API-Key": apiKey]
            )
            
            guard let character = response.characters.first else {
                throw ACDBError.characterNotFound
            }
            
            return CharacterDetails(
                id: character.id,
                name: character.name,
                animeName: character.anime,
                description: character.description ?? "No description available",
                imageUrl: character.image_url
            )
        }
    }
}

// Rate limiter to prevent API abuse
class RateLimiter {
    private let requestsPerSecond: Int
    private var lastRequestTime: Date = .distantPast
    private let queue = DispatchQueue(label: "com.app.ratelimiter")
    
    init(requestsPerSecond: Int) {
        self.requestsPerSecond = requestsPerSecond
    }
    
    func execute<T>(_ block: () async throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            queue.async { [weak self] in
                guard let self = self else { return }
                
                let timeSinceLastRequest = Date().timeIntervalSince(self.lastRequestTime)
                let minimumInterval = 1.0 / Double(self.requestsPerSecond)
                
                if timeSinceLastRequest < minimumInterval {
                    Thread.sleep(forTimeInterval: minimumInterval - timeSinceLastRequest)
                }
                
                self.lastRequestTime = Date()
                
                Task {
                    do {
                        let result = try await block()
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
} 