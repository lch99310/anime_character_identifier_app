import Foundation

extension NetworkService {
    enum RetryStrategy {
        case none
        case fixed(attempts: Int, delay: TimeInterval)
        case exponential(maxAttempts: Int, initialDelay: TimeInterval)
    }
    
    func postWithRetry<T: Encodable, U: Decodable>(
        url: String,
        body: T,
        headers: [String: String] = [:],
        strategy: RetryStrategy = .exponential(maxAttempts: 3, initialDelay: 1)
    ) async throws -> U {
        var attempt = 1
        var delay: TimeInterval = 1
        
        while true {
            do {
                return try await post(url: url, body: body, headers: headers)
            } catch {
                switch strategy {
                case .none:
                    throw error
                case .fixed(let attempts, let fixedDelay):
                    if attempt >= attempts {
                        throw error
                    }
                    delay = fixedDelay
                case .exponential(let maxAttempts, let initialDelay):
                    if attempt >= maxAttempts {
                        throw error
                    }
                    delay = initialDelay * pow(2, Double(attempt - 1))
                }
                
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                attempt += 1
            }
        }
    }
} 