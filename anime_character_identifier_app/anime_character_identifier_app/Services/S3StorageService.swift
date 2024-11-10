import Foundation
import AWSS3

enum S3Error: Error {
    case uploadFailed
    case invalidData
    case configurationError
}

class S3StorageService {
    private let bucketName: String
    private let region: String
    private let accessKey: String
    private let secretKey: String
    
    init(bucketName: String = ProcessInfo.processInfo.environment["AWS_BUCKET_NAME"] ?? "",
         region: String = ProcessInfo.processInfo.environment["AWS_REGION"] ?? "",
         accessKey: String = ProcessInfo.processInfo.environment["AWS_ACCESS_KEY"] ?? "",
         secretKey: String = ProcessInfo.processInfo.environment["AWS_SECRET_KEY"] ?? "") {
        self.bucketName = bucketName
        self.region = region
        self.accessKey = accessKey
        self.secretKey = secretKey
        
        configureAWS()
    }
    
    private func configureAWS() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: accessKey, secretKey: secretKey)
        let configuration = AWSServiceConfiguration(
            region: AWSRegionType(rawValue: region) ?? .USEast1,
            credentialsProvider: credentialsProvider
        )
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func uploadImage(_ imageData: Data) async throws -> String {
        let fileName = UUID().uuidString + ".jpg"
        let uploadRequest = AWSS3TransferManagerUploadRequest()!
        uploadRequest.bucket = bucketName
        uploadRequest.key = fileName
        uploadRequest.body = imageData
        uploadRequest.contentType = "image/jpeg"
        uploadRequest.acl = .publicRead
        
        return try await withCheckedThrowingContinuation { continuation in
            AWSS3TransferManager.default().upload(uploadRequest).continueWith { task in
                if let error = task.error {
                    continuation.resume(throwing: error)
                    return nil
                }
                
                let imageUrl = "https://\(self.bucketName).s3.\(self.region).amazonaws.com/\(fileName)"
                continuation.resume(returning: imageUrl)
                return nil
            }
        }
    }
} 