import Foundation
import UIKit

enum Spatial3DFilesExporter {
    static func export(image: UIImage, suggestedName: String = "Spatial3DConverted") throws -> URL {
        let directory = FileManager.default.temporaryDirectory
        let url = directory.appendingPathComponent("\(suggestedName).jpg")
        guard let data = image.jpegData(compressionQuality: 0.95) else {
            throw Spatial3DConversionError.exportFailed("Could not encode JPEG.")
        }
        try data.write(to: url, options: .atomic)
        return url
    }
}
