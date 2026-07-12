import Foundation
import UIKit

@MainActor
final class Spatial3DGalleryStore: ObservableObject {
    @Published private(set) var items: [Spatial3DConvertedMedia] = []

    private let fileManager = FileManager.default

    private var galleryDirectory: URL {
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("Spatial3DConverter/Gallery", isDirectory: true)
        try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    func add(image: UIImage, settings: Spatial3DConversionSettings) throws -> Spatial3DConvertedMedia {
        let id = UUID()
        let fileURL = galleryDirectory.appendingPathComponent("\(id.uuidString).jpg")
        guard let data = image.jpegData(compressionQuality: 0.92) else {
            throw Spatial3DConversionError.exportFailed("Could not encode gallery image.")
        }
        try data.write(to: fileURL)

        let item = Spatial3DConvertedMedia(
            id: id,
            type: .photo,
            filePath: fileURL.path,
            strength: settings.strength,
            outputFormat: settings.outputFormat,
            engineMode: settings.engineMode,
            status: .complete
        )
        items.insert(item, at: 0)
        return item
    }

    func remove(_ item: Spatial3DConvertedMedia) {
        try? fileManager.removeItem(atPath: item.filePath)
        items.removeAll { $0.id == item.id }
    }

    func image(for item: Spatial3DConvertedMedia) -> UIImage? {
        UIImage(contentsOfFile: item.filePath)
    }
}
