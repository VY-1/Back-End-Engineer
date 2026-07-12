import Foundation
import UIKit

enum Spatial3DExportCoordinator {
    static func exportPhoto(
        left: UIImage,
        right: UIImage,
        sbs: UIImage,
        settings: Spatial3DConversionSettings,
        galleryStore: Spatial3DGalleryStore
    ) async throws -> Spatial3DConvertedMedia {
        switch settings.outputFormat {
        case .spatialPhoto:
            let url = try galleryDirectoryURL().appendingPathComponent("\(UUID().uuidString).heic")
            try Spatial3DSpatialPhotoWriter.writeSpatialPhoto(left: left, right: right, to: url)
            return Spatial3DConvertedMedia(
                type: .photo,
                filePath: url.path,
                strength: settings.strength,
                outputFormat: settings.outputFormat,
                engineMode: settings.engineMode,
                status: .complete
            )
        default:
            return try galleryStore.add(image: sbs, settings: settings)
        }
    }

    static func galleryDirectoryURL() throws -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("Spatial3DConverter/Gallery", isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }
}
