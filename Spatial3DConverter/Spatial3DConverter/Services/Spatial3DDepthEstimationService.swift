import CoreImage
import CoreVideo
import Foundation
import UIKit

/// Loads and runs on-device depth models for Spatial3D Converter.
/// On iOS 26+, replace the placeholder inference path with Core AI model execution.
@MainActor
final class Spatial3DDepthEstimationService {
    static let shared = Spatial3DDepthEstimationService()

    private(set) var isModelLoaded = false
    private(set) var isLoadingModel = false

    private init() {}

    func prepareModels(for mode: Spatial3DEngineMode) async throws {
        guard !isModelLoaded else { return }
        isLoadingModel = true
        defer { isLoadingModel = false }

        // Placeholder warm-up. In Xcode 26, load AOT-compiled Core AI bundles:
        // Spatial3DDepthV2Small.coreai, Spatial3DVideoDepthSmall.coreai, Spatial3DDepthV2Base.coreai
        try await Task.sleep(nanoseconds: 300_000_000)
        isModelLoaded = true
    }

    func estimateDepth(from image: UIImage, mode: Spatial3DEngineMode) async throws -> CIImage {
        try await prepareModels(for: mode)
        guard let ciImage = CIImage(image: image) else {
            throw Spatial3DConversionError.invalidInput
        }
        return generatePlaceholderDepthMap(from: ciImage)
    }

    func estimateDepth(from pixelBuffer: CVPixelBuffer, mode: Spatial3DEngineMode) async throws -> CIImage {
        try await prepareModels(for: mode)
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        return generatePlaceholderDepthMap(from: ciImage)
    }

    private func generatePlaceholderDepthMap(from image: CIImage) -> CIImage {
        let extent = image.extent
        guard let radial = CIFilter(name: "CIRadialGradient") else { return image }
        radial.setValue(CIVector(x: extent.midX, y: extent.midY), forKey: "inputCenter")
        radial.setValue(min(extent.width, extent.height) * 0.15, forKey: "inputRadius0")
        radial.setValue(max(extent.width, extent.height) * 0.75, forKey: "inputRadius1")
        radial.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor0")
        radial.setValue(CIColor(red: 0, green: 0, blue: 0), forKey: "inputColor1")
        return radial.outputImage?.cropped(to: extent) ?? image
    }
}
