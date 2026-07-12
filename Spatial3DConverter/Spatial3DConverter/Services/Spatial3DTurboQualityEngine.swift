import CoreImage
import Foundation
import UIKit

@MainActor
final class Spatial3DTurboQualityEngine: ObservableObject {
    @Published private(set) var isProcessing = false
    @Published private(set) var progress = Spatial3DConversionProgress.zero
    @Published private(set) var previewImage: UIImage?
    @Published var lastError: String?

    private let depthService = Spatial3DDepthEstimationService.shared
    private let context = CIContext()

    func convertPhoto(_ image: UIImage, settings: Spatial3DConversionSettings) async throws -> UIImage {
        isProcessing = true
        lastError = nil
        defer { isProcessing = false }

        let cacheKey = "photo-\(settings.engineMode.rawValue)"
        let depth: CIImage
        if let cached = await Spatial3DDepthCache.shared.depth(forKey: cacheKey) {
            depth = cached
        } else {
            depth = try await depthService.estimateDepth(from: image, mode: settings.engineMode)
            await Spatial3DDepthCache.shared.store(depth: depth, forKey: cacheKey)
        }

        guard let source = CIImage(image: image) else {
            throw Spatial3DConversionError.invalidInput
        }

        let refined = Spatial3DDepthRefinementService.refine(depth, previous: nil)
        let pair = Spatial3DStereoGenerator.generateStereoPair(
            from: source,
            depth: refined,
            strength: settings.strength
        )

        let outputCI: CIImage
        switch settings.outputFormat {
        case .topBottomVR:
            outputCI = Spatial3DSBSEncoder.encode(left: pair.left, right: pair.right, layout: .topBottomVR)
        default:
            outputCI = Spatial3DSBSEncoder.encode(left: pair.left, right: pair.right, layout: .sbsVR)
        }

        guard let output = Spatial3DStereoGenerator.renderUIImage(from: outputCI, context: context) else {
            throw Spatial3DConversionError.exportFailed("Could not render output image.")
        }

        previewImage = output
        progress = Spatial3DConversionProgress(
            fractionComplete: 1,
            processedFrames: 1,
            totalFrames: 1,
            elapsedSeconds: 0,
            estimatedRemainingSeconds: 0
        )
        return output
    }

    func updatePreview(from image: UIImage, settings: Spatial3DConversionSettings) async {
        do {
            _ = try await convertPhoto(image, settings: settings)
        } catch {
            lastError = error.localizedDescription
        }
    }
}
