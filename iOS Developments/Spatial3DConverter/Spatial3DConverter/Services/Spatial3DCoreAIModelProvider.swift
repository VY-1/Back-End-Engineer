import CoreImage
import CoreVideo
import Foundation
import UIKit

/// Abstraction for Core AI depth inference on iOS 26+.
protocol Spatial3DCoreAIModelProviding {
    func prepare(mode: Spatial3DEngineMode) async throws
    func estimateDepth(from image: CIImage, mode: Spatial3DEngineMode) async throws -> CIImage
    func estimateDepth(from pixelBuffer: CVPixelBuffer, mode: Spatial3DEngineMode) async throws -> CIImage
}

/// Default provider: placeholder depth until AOT Core AI bundles are linked in Xcode.
final class Spatial3DPlaceholderCoreAIProvider: Spatial3DCoreAIModelProviding {
    private var isPrepared = false

    func prepare(mode: Spatial3DEngineMode) async throws {
        guard !isPrepared else { return }
        // On device, load:
        // Spatial3DDepthV2Small.coreai (turbo)
        // Spatial3DVideoDepthSmall.coreai (quality)
        // Spatial3DDepthV2Base.coreai (photo)
        try await Task.sleep(nanoseconds: 150_000_000)
        isPrepared = true
    }

    func estimateDepth(from image: CIImage, mode: Spatial3DEngineMode) async throws -> CIImage {
        try await prepare(mode: mode)
        return generateDepth(from: image, mode: mode)
    }

    func estimateDepth(from pixelBuffer: CVPixelBuffer, mode: Spatial3DEngineMode) async throws -> CIImage {
        try await prepare(mode: mode)
        return generateDepth(from: CIImage(cvPixelBuffer: pixelBuffer), mode: mode)
    }

    private func generateDepth(from image: CIImage, mode: Spatial3DEngineMode) -> CIImage {
        let extent = image.extent
        let centerBias: CGFloat = mode == .quality ? 0.55 : 0.45
        guard let radial = CIFilter(name: "CIRadialGradient") else { return image }
        radial.setValue(CIVector(x: extent.midX, y: extent.midY * centerBias), forKey: "inputCenter")
        radial.setValue(min(extent.width, extent.height) * 0.12, forKey: "inputRadius0")
        radial.setValue(max(extent.width, extent.height) * 0.8, forKey: "inputRadius1")
        radial.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor0")
        radial.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor1")
        return radial.outputImage?.cropped(to: extent) ?? image
    }
}
