import Foundation

struct Character {
    let id: Int
    let name: String
    let imageUrl: String
    let animeTitle: String
    let description: String
    
    init(from acdbCharacter: ACDBCharacter) {
        self.id = acdbCharacter.id
        self.name = acdbCharacter.name
        self.imageUrl = acdbCharacter.character_image
        self.animeTitle = acdbCharacter.anime_name
        self.description = acdbCharacter.desc
    }
} 