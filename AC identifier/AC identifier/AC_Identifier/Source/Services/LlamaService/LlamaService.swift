import UIKit

class LlamaService {
    static let shared = LlamaService()
    
    private let apiKey = AppConfig.llamaApiKey
    private let apiUrl = "https://api.groq.com/openai/v1/chat/completions"
    private let imageProcessor = ImageProcessor()
    
    private init() {}
    
    func identifyCharacter(from image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard AppConfig.validateAPIKeys() else {
            completion(.failure(AppError.configurationError))
            return
        }
        
        // 步驟1: 調整圖片尺寸
        let size = CGSize(width: 256, height: 256) // 降低到256x256
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        image.draw(in: CGRect(origin: .zero, size: size))
        guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            completion(.failure(AppError.imageProcessingFailed))
            return
        }
        UIGraphicsEndImageContext()
        
        // 步驟2: 強力壓縮
        guard let processedImage = compressImage(resizedImage, maxSize: 20 * 1024) else { // 限制20KB
            completion(.failure(AppError.imageProcessingFailed))
            return
        }
        
        print("壓縮率: \(String(format: "%.1f", CGFloat(processedImage.count) / CGFloat(image.jpegData(compressionQuality: 1.0)?.count ?? 1) * 100))%, 大小: \(processedImage.count) bytes")
        
        var request = URLRequest(url: URL(string: apiUrl)!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = AppConfig.requestTimeout
        
        let base64Image = processedImage.base64EncodedString()
        print("圖片已轉換為base64格式，大小：\(base64Image.count) bytes")
        
        // 步驟3: 簡化請求內容
        let requestBody: [String: Any] = [
            "model": AppConfig.llamaModel,
            "messages": [
                [
                    "role": "system",
                    "content": AppConfig.llamaSystemPrompt
                ],
                [
                    "role": "user",
                    "content": "\(AppConfig.llamaUserPrompt)\ndata:image/jpeg;base64,\(base64Image)"
                ]
            ],
            "temperature": AppConfig.llamaTemperature,
            "max_tokens": AppConfig.llamaMaxTokens
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            print("請求大小：\(request.httpBody?.count ?? 0) bytes")
        } catch {
            print("請求序列化失敗：\(error.localizedDescription)")
            completion(.failure(AppError.imageProcessingFailed))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("網絡錯誤：\(error.localizedDescription)")
                completion(.failure(AppError.networkError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("無效的HTTP響應")
                completion(.failure(AppError.networkError))
                return
            }
            
            print("收到HTTP響應，狀態碼：\(httpResponse.statusCode)")
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if let data = data, let errorString = String(data: data, encoding: .utf8) {
                    print("伺服器錯誤：\(errorString)")
                }
                completion(.failure(AppError.serverError(httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                print("沒有收到數據")
                completion(.failure(AppError.networkError))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                
                if let error = json?["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    print("API錯誤：\(message)")
                    completion(.failure(AppError.apiError(message)))
                    return
                }
                
                guard let choices = json?["choices"] as? [[String: Any]],
                      let firstChoice = choices.first,
                      let message = firstChoice["message"] as? [String: Any],
                      let content = message["content"] as? String else {
                    print("無效的API響應格式")
                    completion(.failure(AppError.invalidResponse))
                    return
                }
                
                let cleanedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "Character:", with: "")
                    .replacingOccurrences(of: " ", with: "")
                print("識別結果：\(cleanedContent)")
                completion(.success(cleanedContent))
                
            } catch {
                print("JSON解析錯誤：\(error.localizedDescription)")
                completion(.failure(AppError.apiError("響應解析失敗")))
            }
        }
        
        task.resume()
    }
    
    // 圖片壓縮
    private func compressImage(_ image: UIImage, maxSize: Int) -> Data? {
        var compression: CGFloat = 0.8 // 從0.8開始
        let step: CGFloat = 0.1
        
        guard var imageData = image.jpegData(compressionQuality: compression) else {
            return nil
        }
        
        print("壓縮率: \(compression), 大小: \(imageData.count) bytes")
        
        while imageData.count > maxSize && compression > 0.1 {
            compression -= step
            if let data = image.jpegData(compressionQuality: compression) {
                imageData = data
                print("壓縮率: \(compression), 大小: \(imageData.count) bytes")
            }
        }
        
        return imageData
    }
}