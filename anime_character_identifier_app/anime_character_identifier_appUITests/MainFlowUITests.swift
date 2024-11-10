import XCTest

class MainFlowUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI-Testing"]
        app.launch()
    }
    
    func testCameraButtonExists() {
        // Then
        XCTAssertTrue(app.buttons["Take Photo"].exists)
    }
    
    func testLibraryButtonExists() {
        // Then
        XCTAssertTrue(app.buttons["Choose from Library"].exists)
    }
    
    func testCameraFlowShowsPermissionAlert() {
        // When
        app.buttons["Take Photo"].tap()
        
        // Then
        XCTAssertTrue(app.alerts["Permission Required"].exists)
        XCTAssertTrue(app.alerts["Permission Required"].buttons["Settings"].exists)
        XCTAssertTrue(app.alerts["Permission Required"].buttons["Cancel"].exists)
    }
    
    func testPhotoLibraryFlow() {
        // Given
        let imagePicker = app.otherElements["Photo picker"]
        
        // When
        app.buttons["Choose from Library"].tap()
        
        // Then
        XCTAssertTrue(imagePicker.exists)
    }
    
    func testProcessingViewAppearsAfterImageSelection() {
        // Given
        let processingView = app.otherElements["ProcessingView"]
        
        // When
        simulateImageSelection()
        
        // Then
        XCTAssertTrue(processingView.exists)
        XCTAssertTrue(processingView.staticTexts["Processing image..."].exists)
    }
    
    func testResultsViewAppearsAfterProcessing() {
        // Given
        let resultsView = app.otherElements["ResultsView"]
        
        // When
        simulateSuccessfulImageProcessing()
        
        // Then
        XCTAssertTrue(resultsView.exists)
        XCTAssertTrue(resultsView.staticTexts["Character Details"].exists)
    }
    
    // Helper methods
    private func simulateImageSelection() {
        app.buttons["Choose from Library"].tap()
        // Simulate image selection from library
        // Note: This is a mock implementation for testing
    }
    
    private func simulateSuccessfulImageProcessing() {
        simulateImageSelection()
        // Wait for processing to complete
        let resultsView = app.otherElements["ResultsView"]
        XCTAssertTrue(resultsView.waitForExistence(timeout: 5.0))
    }
} 