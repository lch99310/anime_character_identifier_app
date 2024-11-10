import Foundation

struct CharacterSearchResponse: Codable {
    let searchTerm: String
    let searchResults: [CharacterInfo]
    
    enum CodingKeys: String, CodingKey {
        case searchTerm = "search_term"
        case searchResults = "search_results"
    }
}

struct CharacterInfo: Codable {
    let animeId: Int
    let animeName: String
    let animeImage: String
    let characterImage: String
    let id: Int
    let gender: String
    let name: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case animeId = "anime_id"
        case animeName = "anime_name"
        case animeImage = "anime_image"
        case characterImage = "character_image"
        case id
        case gender
        case name
        case description = "desc"
    }
} 