import XCTest
import AVFoundation
@testable import anime_character_identifier_app

class CameraManagerTests: XCTestCase {
    var sut: CameraManager!
    
    override func setUp() {
        super.setUp()
        sut = CameraManager.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSetupCameraFailsWithoutPermission() async {
        // Given
        let authorizationStatus: AVAuthorizationStatus = .denied
        
        // When/Then
        do {
            _ = try await withCheckedThrowingContinuation { continuation in
                AVCaptureDevice.requestAccess(for: .video) { _ in
                    continuation.resume()
                }
            }
            try sut.setupCamera()
            XCTFail("Expected setup to fail without permission")
        } catch {
            XCTAssertTrue(error is CameraError)
            XCTAssertEqual(error as? CameraError, .noPermission)
        }
    }
    
    func testCapturePhotoFailsWithoutSession() {
        // Given
        var captureError: Error?
        let expectation = XCTestExpectation(description: "Capture completion")
        
        // When
        sut.capturePhoto { result in
            switch result {
            case .success:
                XCTFail("Expected capture to fail without session")
            case .failure(let error):
                captureError = error
            }
            expectation.fulfill()
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(captureError)
        XCTAssertTrue(captureError is CameraError)
        XCTAssertEqual(captureError as? CameraError, .captureError)
    }
} 