import XCTest
@testable import anime_character_identifier_app

class NetworkServiceTests: XCTestCase {
    var sut: NetworkService!
    var mockSession: MockURLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        sut = NetworkService(session: mockSession)
    }
    
    override func tearDown() {
        sut = nil
        mockSession = nil
        super.tearDown()
    }
    
    func testPostSuccess() async throws {
        // Given
        struct TestRequest: Codable {
            let message: String
        }
        struct TestResponse: Codable {
            let status: String
        }
        
        let expectedResponse = TestResponse(status: "success")
        mockSession.nextData = try JSONEncoder().encode(expectedResponse)
        mockSession.nextResponse = HTTPURLResponse(
            url: URL(string: "https://test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        // When
        let response: TestResponse = try await sut.post(
            url: "https://test.com",
            body: TestRequest(message: "hello")
        )
        
        // Then
        XCTAssertEqual(response.status, expectedResponse.status)
    }
    
    func testPostWithRetrySuccess() async throws {
        // Given
        struct TestRequest: Codable { let id: Int }
        struct TestResponse: Codable { let result: String }
        
        mockSession.responses = [
            (error: URLError(.networkConnectionLost), response: nil),
            (error: nil, response: HTTPURLResponse(
                url: URL(string: "https://test.com")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ))
        ]
        mockSession.nextData = try JSONEncoder().encode(TestResponse(result: "success"))
        
        // When
        let response: TestResponse = try await sut.postWithRetry(
            url: "https://test.com",
            body: TestRequest(id: 1),
            strategy: .fixed(attempts: 2, delay: 0.1)
        )
        
        // Then
        XCTAssertEqual(response.result, "success")
        XCTAssertEqual(mockSession.requestCount, 2)
    }
}

// Mock URLSession for testing
class MockURLSession: URLSession {
    var nextData: Data?
    var nextError: Error?
    var nextResponse: URLResponse?
    var requestCount = 0
    
    var responses: [(error: Error?, response: URLResponse?)] = []
    
    override func data(
        for request: URLRequest,
        delegate: URLSessionTaskDelegate? = nil
    ) async throws -> (Data, URLResponse) {
        requestCount += 1
        
        if !responses.isEmpty {
            let response = responses.removeFirst()
            if let error = response.error {
                throw error
            }
            return (nextData ?? Data(), response.response!)
        }
        
        if let error = nextError {
            throw error
        }
        
        return (nextData ?? Data(), nextResponse!)
    }
} 