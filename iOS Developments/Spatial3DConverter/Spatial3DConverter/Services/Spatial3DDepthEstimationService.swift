import CoreImage
import CoreVideo
import Foundation
import UIKit

@MainActor
final class Spatial3DDepthEstimationService {
    static let shared = Spatial3DDepthEstimationService()

    private(set) var isModelLoaded = false
    private(set) var isLoadingModel = false
    private var provider: Spatial3DCoreAIModelProviding = Spatial3DPlaceholderCoreAIProvider()

    private init() {}

    func setProvider(_ provider: Spatial3DCoreAIModelProviding) {
        self.provider = provider
        isModelLoaded = false
    }

    func prepareModels(for mode: Spatial3DEngineMode) async throws {
        guard !isModelLoaded else { return }
        isLoadingModel = true
        defer { isLoadingModel = false }
        try await provider.prepare(mode: mode)
        isModelLoaded = true
    }

    func estimateDepth(from image: UIImage, mode: Spatial3DEngineMode) async throws -> CIImage {
        try await prepareModels(for: mode)
        guard let ciImage = CIImage(image: image) else {
            throw Spatial3DConversionError.invalidInput
        }
        return try await provider.estimateDepth(from: ciImage, mode: mode)
    }

    func estimateDepth(from pixelBuffer: CVPixelBuffer, mode: Spatial3DEngineMode) async throws -> CIImage {
        try await prepareModels(for: mode)
        return try await provider.estimateDepth(from: pixelBuffer, mode: mode)
    }
}
