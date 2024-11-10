import Foundation

// MARK: - Models Namespace
enum Models {
    // MARK: - ACDB Models
    struct ACDBResponse: Codable {
        let search_term: String
        let search_results: [ACDBCharacter]
    }

    struct ACDBCharacter: Codable {
        let id: Int
        let name: String
        let character_image: String
        let anime_name: String
        let desc: String
        let gender: String
        let anime_id: Int
        let anime_image: String
    }

    // MARK: - Llama Models
    struct LlamaIdentification {
        let englishName: String
        let japaneseName: String
        let animeName: String
        
        var searchableName: String {
            return englishName != "Unknown" ? englishName : japaneseName
        }
        
        static func parse(from llamaResponse: String) -> LlamaIdentification {
            var englishName = "Unknown"
            var japaneseName = "Unknown"
            var animeName = "Unknown"
            
            let lines = llamaResponse.components(separatedBy: .newlines)
            for line in lines {
                let cleanLine = line.trimmingCharacters(in: .whitespaces)
                if cleanLine.starts(with: "Character:") {
                    englishName = cleanLine.replacingOccurrences(of: "Character:", with: "").trimmingCharacters(in: .whitespaces)
                } else if cleanLine.starts(with: "Japanese Name:") {
                    japaneseName = cleanLine.replacingOccurrences(of: "Japanese Name:", with: "").trimmingCharacters(in: .whitespaces)
                } else if cleanLine.starts(with: "From:") {
                    animeName = cleanLine.replacingOccurrences(of: "From:", with: "").trimmingCharacters(in: .whitespaces)
                }
            }
            
            return LlamaIdentification(
                englishName: englishName,
                japaneseName: japaneseName,
                animeName: animeName
            )
        }
    }
} 