import Foundation

class AnimeDBService {
    static let shared = AnimeDBService()
    
    private let baseUrl = AppConfig.animeDBApiUrl
    private let userAgent = AppConfig.acdbUserAgent
    private let requestQueue = DispatchQueue(label: "com.acidentifier.api.queue")
    private var lastRequestTime: Date?
    
    private init() {}
    
    // MARK: - Rate Limiting
    private func waitForRateLimit(completion: @escaping () -> Void) {
        requestQueue.async { [weak self] in
            guard let self = self else { return }
            
            if let lastRequest = self.lastRequestTime {
                let timeSinceLastRequest = Date().timeIntervalSince(lastRequest)
                if timeSinceLastRequest < AppConfig.acdbRequestInterval {
                    let delayTime = AppConfig.acdbRequestInterval - timeSinceLastRequest
                    Thread.sleep(forTimeInterval: delayTime)
                }
            }
            
            self.lastRequestTime = Date()
            completion()
        }
    }
    
    // MARK: - Character Search
    func searchCharacter(name: String, completion: @escaping (Result<[Models.ACDBCharacter], Error>) -> Void) {
        // 清理搜索字符串
        let searchName = name
            .replacingOccurrences(of: "Character:", with: "")
            .replacingOccurrences(of: "Japanese:", with: "")
            .replacingOccurrences(of: "From:", with: "")
            .replacingOccurrences(of: ",", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 處理名字格式
        let formattedName = formatCharacterName(searchName)
        
        guard let encodedName = formattedName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)?character_q=\(encodedName)") else {
            completion(.failure(AppError.invalidURL))
            return
        }
        
        print("搜索URL: \(url.absoluteString)")
        
        waitForRateLimit { [weak self] in
            guard let self = self else { return }
            
            var request = URLRequest(url: url)
            request.setValue(self.userAgent, forHTTPHeaderField: "User-Agent")
            request.timeoutInterval = AppConfig.requestTimeout
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("網絡錯誤: \(error.localizedDescription)")
                    completion(.failure(AppError.networkError))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 402 {
                        completion(.failure(AppError.userAgentRequired))
                        return
                    }
                    
                    // 檢查-1響應
                    if httpResponse.statusCode == 200,
                       let data = data,
                       let responseString = String(data: data, encoding: .utf8),
                       responseString == "-1" {
                        print("沒有找到角色")
                        completion(.success([]))
                        return
                    }
                }
                
                guard let data = data else {
                    print("沒有收到數據")
                    completion(.failure(AppError.networkError))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Models.ACDBResponse.self, from: data)
                    print("成功解析到 \(response.search_results.count) 個角色")
                    completion(.success(response.search_results))
                } catch {
                    print("JSON解析錯誤: \(error.localizedDescription)")
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("原始數據: \(responseString)")
                    }
                    completion(.failure(AppError.apiError("數據解析失敗")))
                }
            }
            
            task.resume()
        }
    }
    
    // 名字格式化邏輯
    private func formatCharacterName(_ name: String) -> String {
        // 1. 先移除所有空格
        var formattedName = name.replacingOccurrences(of: " ", with: "")
        
        // 2. 找出所有大寫字母的位置
        var capitalIndexes: [String.Index] = []
        formattedName.enumerated().forEach { offset, char in
            let index = formattedName.index(formattedName.startIndex, offsetBy: offset)
            if char.isUppercase && offset > 0 {
                capitalIndexes.append(index)
            }
        }
        
        // 3. 從後往前在大寫字母前插入空格
        for index in capitalIndexes.reversed() {
            formattedName.insert(" ", at: index)
        }
        
        // 4. 移除多餘的空格並修剪
        return formattedName
            .replacingOccurrences(of: "  ", with: " ")
            .trimmingCharacters(in: .whitespaces)
    }
}

// MARK: - ACDB API Response Models
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