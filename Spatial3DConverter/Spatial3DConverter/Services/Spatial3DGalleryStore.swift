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

    @discardableResult
    func add(image: UIImage, settings: Spatial3DConversionSettings) throws -> Spatial3DConvertedMedia {
        let item = try persistImage(image, settings: settings)
        items.insert(item, at: 0)
        return item
    }

    func insert(_ item: Spatial3DConvertedMedia) {
        items.insert(item, at: 0)
    }

    func remove(_ item: Spatial3DConvertedMedia) {
        try? fileManager.removeItem(atPath: item.filePath)
        items.removeAll { $0.id == item.id }
    }

    func image(for item: Spatial3DConvertedMedia) -> UIImage? {
        UIImage(contentsOfFile: item.filePath)
    }

    func fileURL(for item: Spatial3DConvertedMedia) -> URL {
        URL(fileURLWithPath: item.filePath)
    }

    private func persistImage(_ image: UIImage, settings: Spatial3DConversionSettings) throws -> Spatial3DConvertedMedia {
        let id = UUID()
        let fileURL = galleryDirectory.appendingPathComponent("\(id.uuidString).jpg")
        guard let data = image.jpegData(compressionQuality: 0.92) else {
            throw Spatial3DConversionError.exportFailed("Could not encode gallery image.")
        }
        try data.write(to: fileURL)
        return Spatial3DConvertedMedia(
            id: id,
            type: .photo,
            filePath: fileURL.path,
            strength: settings.strength,
            outputFormat: settings.outputFormat,
            engineMode: settings.engineMode,
            status: .complete
        )
    }
}
