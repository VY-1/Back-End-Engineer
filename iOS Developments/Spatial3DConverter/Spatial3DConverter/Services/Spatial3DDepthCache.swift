import CoreImage
import Foundation

actor Spatial3DDepthCache {
    static let shared = Spatial3DDepthCache()

    private var memoryCache: [String: CIImage] = [:]
    private let fileManager = FileManager.default

    private var cacheDirectory: URL {
        let base = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = base.appendingPathComponent("Spatial3DConverter/DepthCache", isDirectory: true)
        try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    func store(depth: CIImage, forKey key: String) {
        memoryCache[key] = depth
    }

    func depth(forKey key: String) -> CIImage? {
        memoryCache[key]
    }

    func clear() {
        memoryCache.removeAll()
        if let files = try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil) {
            files.forEach { try? fileManager.removeItem(at: $0) }
        }
    }
}
