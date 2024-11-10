import Foundation
import UIKit

enum LocalStorageError: Error {
    case saveFailed
    case invalidData
}

class LocalStorageService {
    private let fileManager: FileManager
    private let temporaryDirectory: URL
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.temporaryDirectory = fileManager.temporaryDirectory
    }
    
    func uploadImage(_ imageData: Data) async throws -> String {
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try imageData.write(to: fileURL)
            return fileURL.absoluteString
        } catch {
            throw LocalStorageError.saveFailed
        }
    }
    
    func cleanupTemporaryFiles() {
        do {
            let contents = try fileManager.contentsOfDirectory(
                at: temporaryDirectory,
                includingPropertiesForKeys: nil,
                options: []
            )
            
            for file in contents where file.pathExtension == "jpg" {
                try? fileManager.removeItem(at: file)
            }
        } catch {
            print("Failed to cleanup temporary files: \(error)")
        }
    }
} 