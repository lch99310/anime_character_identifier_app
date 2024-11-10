import Foundation

enum AppConfig {
    // API Keys
    static let llamaApiKey = "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"
    
    // API Endpoints
    static let llamaApiUrl = "https://api.groq.com/v1/chat/completions"
    static let animeDBApiUrl = "https://www.animecharactersdatabase.com/api_series_characters.php"
    
    // Llama API Settings
    static let llamaModel = "llama-3.2-90b-text-preview"
    static let llamaTemperature = 0.35
    static let llamaMaxTokens = 7000
    
    // Llama Prompts
    static let llamaSystemPrompt = """
    You are an expert anime character identifier specializing in analyzing compressed, lower-quality images. Follow this precise identification process:
    1. Primary Feature Analysis:
    - Focus on most distinctive and compression-resistant features:
    - Overall color schemes (hair, outfit dominant colors)
    - Basic silhouette and character proportions
    - Large, obvious design elements
    - Distinctive color combinations
    2. Detail Compensation:
    - Look for color-stable identifiers
    - Focus on high-contrast elements
    - Consider general shape patterns over fine details
    3. Cross-reference with common anime character archetypes
    4. Use context clues from overall character design
    5. CRITICAL: If features are ambiguous due to image quality:
    - Prioritize most reliable visible elements
    - Consider most popular characters matching visible traits
    
    Return ONLY this exact format regardless of confidence:
    Character:[English name]
    """
    
    static let llamaUserPrompt = """
    Analyze this compressed anime character image (256x256, JPEG). Focus on prominent color patterns and distinctive shapes. Identify the character using only the most reliable visual elements. Provide ONLY the name in format: Character:[English name]
    """
    
    // ACDB API Settings
    static let acdbUserAgent = "AC_Identifier/1.0 (iOS; Contact: your@email.com)"
    static let acdbRequestInterval: TimeInterval = 1.0 // 1秒限制
    
    // Cache Settings
    static let maxCacheSize = 100 * 1024 * 1024 // 100 MB
    static let maxCacheItems = 100
    
    // Image Settings
    static let maxImageDimension: CGFloat = 1024
    static let imageCompressionQuality: CGFloat = 0.8
    
    // Network Settings
    static let requestTimeout: TimeInterval = 30
    static let resourceTimeout: TimeInterval = 300
    
    // Validation
    static func validateAPIKeys() -> Bool {
        guard !llamaApiKey.isEmpty && llamaApiKey != "YOUR_API_KEY" else {
            print("錯誤：Llama API Key 未設置")
            return false
        }
        return true
    }
}