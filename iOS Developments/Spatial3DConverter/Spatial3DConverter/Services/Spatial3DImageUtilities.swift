import CoreImage
import CoreVideo
import UIKit

enum Spatial3DImageUtilities {
    static let sharedContext = CIContext(options: [.useSoftwareRenderer: false])

    static func ciImage(from pixelBuffer: CVPixelBuffer) -> CIImage {
        CIImage(cvPixelBuffer: pixelBuffer)
    }

    static func uiImage(from ciImage: CIImage, context: CIContext = sharedContext) -> UIImage? {
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    static func pixelBuffer(from ciImage: CIImage, size: CGSize, context: CIContext = sharedContext) -> CVPixelBuffer? {
        var buffer: CVPixelBuffer?
        let attrs: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        CVPixelBufferCreate(
            kCFAllocatorDefault,
            Int(size.width),
            Int(size.height),
            kCVPixelFormatType_32BGRA,
            attrs as CFDictionary,
            &buffer
        )
        guard let buffer else { return nil }
        context.render(ciImage, to: buffer)
        return buffer
    }

    static func cacheKey(for data: Data) -> String {
        String(data.hashValue)
    }
}
