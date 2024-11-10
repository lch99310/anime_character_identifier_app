import Foundation

struct CharacterDetails: Codable {
    let id: Int
    let name: String
    let animeName: String
    let description: String
    let imageUrl: String
}

struct VideoResult: Codable {
    let videoId: String
    let title: String
    let thumbnailUrl: String
    let description: String
}

struct CharacterIdentification: Codable {
    let name: String
    let animeName: String
    let confidence: Float
} 