import AVFoundation
import Photos
import UIKit

enum CameraError: Error {
    case deviceNotAvailable
    case configurationFailed
    case captureError
    case noPermission
}

class CameraManager: NSObject {
    static let shared = CameraManager()
    
    private var captureSession: AVCaptureSession?
    private let photoOutput = AVCapturePhotoOutput()
    private var completionHandler: ((Result<UIImage, Error>) -> Void)?
    
    func requestPermissions() async throws -> Bool {
        let cameraAuth = await AVCaptureDevice.requestAccess(for: .video)
        let photoAuth = await PHPhotoLibrary.requestAuthorization()
        
        return cameraAuth && photoAuth == .authorized
    }
    
    func setupCamera() throws {
        let session = AVCaptureSession()
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            throw CameraError.deviceNotAvailable
        }
        
        guard let input = try? AVCaptureDeviceInput(device: device) else {
            throw CameraError.configurationFailed
        }
        
        session.beginConfiguration()
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        session.commitConfiguration()
        captureSession = session
    }
    
    func startSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    func stopSession() {
        captureSession?.stopRunning()
    }
    
    func capturePhoto(completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let connection = photoOutput.connection(with: .video) else {
            completion(.failure(CameraError.captureError))
            return
        }
        
        completionHandler = completion
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                    didFinishProcessingPhoto photo: AVCapturePhoto,
                    error: Error?) {
        if let error = error {
            completionHandler?(.failure(error))
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            completionHandler?(.failure(CameraError.captureError))
            return
        }
        
        completionHandler?(.success(image))
    }
} 