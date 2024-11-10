import Foundation

enum YouTubeError: Error {
    case invalidResponse
    case quotaExceeded
    case networkError(Error)
}

class YouTubeService {
    private let networkService: NetworkService
    private let apiKey: String
    private let baseURL = "https://www.googleapis.com/youtube/v3"
    
    init(apiKey: String = ProcessInfo.processInfo.environment["YOUTUBE_API_KEY"] ?? "",
         networkService: NetworkService = NetworkService()) {
        self.apiKey = apiKey
        self.networkService = networkService
    }
    
    struct SearchResponse: Codable {
        let items: [Item]
        
        struct Item: Codable {
            let id: ID
            let snippet: Snippet
            
            struct ID: Codable {
                let videoId: String
            }
            
            struct Snippet: Codable {
                let title: String
                let description: String
                let thumbnails: Thumbnails
                
                struct Thumbnails: Codable {
                    let medium: Thumbnail
                    
                    struct Thumbnail: Codable {
                        let url: String
                    }
                }
            }
        }
    }
    
    func searchVideos(character: String, anime: String) async throws -> [VideoResult] {
        let query = "\(character) \(anime) anime scene"
        let urlString = "\(baseURL)/search?part=snippet&q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query)&type=video&maxResults=10&key=\(apiKey)"
        
        let response: SearchResponse = try await networkService.post(
            url: urlString,
            body: EmptyRequest()
        )
        
        return response.items.map { item in
            VideoResult(
                videoId: item.id.videoId,
                title: item.snippet.title,
                thumbnailUrl: item.snippet.thumbnails.medium.url,
                description: item.snippet.description
            )
        }
    }
}

// Empty request for GET endpoints that require a body type
private struct EmptyRequest: Codable {} 