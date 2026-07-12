import CoreImage
import Foundation
import UIKit

@MainActor
final class Spatial3DTurboQualityEngine: ObservableObject {
    @Published private(set) var isProcessing = false
    @Published private(set) var progress = Spatial3DConversionProgress.zero
    @Published private(set) var previewImage: UIImage?
    @Published private(set) var previewLeftEye: UIImage?
    @Published private(set) var previewRightEye: UIImage?
    @Published var lastError: String?

    private let depthService = Spatial3DDepthEstimationService.shared
    private let context = Spatial3DImageUtilities.sharedContext
    private var activeCacheKey: String?

    func convertPhoto(_ image: UIImage, settings: Spatial3DConversionSettings) async throws -> UIImage {
        isProcessing = true
        lastError = nil
        defer { isProcessing = false }

        let output = try await renderPhoto(image, settings: settings)
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

    func exportConvertedPhoto(
        _ image: UIImage,
        settings: Spatial3DConversionSettings,
        galleryStore: Spatial3DGalleryStore
    ) async throws -> Spatial3DConvertedMedia {
        let rendered = try await renderPhoto(image, settings: settings)
        guard let source = CIImage(image: image) else {
            throw Spatial3DConversionError.invalidInput
        }
        let cacheKey = activeCacheKey ?? UUID().uuidString
        let depth = try await depthForPhoto(image, cacheKey: cacheKey, mode: settings.engineMode)
        let processed = Spatial3DStereoFrameProcessor.process(source: source, depth: depth, settings: settings)
        guard let left = Spatial3DImageUtilities.uiImage(from: processed.left, context: context),
              let right = Spatial3DImageUtilities.uiImage(from: processed.right, context: context) else {
            throw Spatial3DConversionError.exportFailed("Could not render stereo pair.")
        }
        return try await Spatial3DExportCoordinator.exportPhoto(
            left: left,
            right: right,
            sbs: rendered,
            settings: settings,
            galleryStore: galleryStore
        )
    }

    func processVideoFrame(
        pixelBuffer: CVPixelBuffer,
        settings: Spatial3DConversionSettings,
        smoother: Spatial3DTemporalDepthSmoother,
        frameIndex: Int
    ) async throws -> CVPixelBuffer {
        let source = Spatial3DImageUtilities.ciImage(from: pixelBuffer)
        let cacheKey = "video-\(settings.engineMode.rawValue)-\(frameIndex / 30)"
        let rawDepth = try await depthService.estimateDepth(from: pixelBuffer, mode: settings.engineMode)
        await Spatial3DDepthCache.shared.store(depth: rawDepth, forKey: cacheKey)
        let smoothed = smoother.smooth(rawDepth)
        let processed = Spatial3DStereoFrameProcessor.process(
            source: source,
            depth: smoothed,
            settings: settings,
            previousDepth: nil
        )
        let size = CGSize(width: source.extent.width * 2, height: source.extent.height)
        guard let output = Spatial3DImageUtilities.pixelBuffer(from: processed.sbs, size: size, context: context) else {
            throw Spatial3DConversionError.exportFailed("Could not create output pixel buffer.")
        }
        return output
    }

    private func renderPhoto(_ image: UIImage, settings: Spatial3DConversionSettings) async throws -> UIImage {
        guard let source = CIImage(image: image) else {
            throw Spatial3DConversionError.invalidInput
        }
        guard let jpeg = image.jpegData(compressionQuality: 0.95) else {
            throw Spatial3DConversionError.invalidInput
        }
        let cacheKey = Spatial3DImageUtilities.cacheKey(for: jpeg)
        activeCacheKey = cacheKey

        let depth = try await depthForPhoto(image, cacheKey: cacheKey, mode: settings.engineMode)
        let processed = Spatial3DStereoFrameProcessor.process(source: source, depth: depth, settings: settings)
        previewLeftEye = Spatial3DImageUtilities.uiImage(from: processed.left, context: context)
        previewRightEye = Spatial3DImageUtilities.uiImage(from: processed.right, context: context)

        guard let output = Spatial3DImageUtilities.uiImage(from: processed.sbs, context: context) else {
            throw Spatial3DConversionError.exportFailed("Could not render output image.")
        }
        return output
    }

    private func depthForPhoto(_ image: UIImage, cacheKey: String, mode: Spatial3DEngineMode) async throws -> CIImage {
        if let cached = await Spatial3DDepthCache.shared.depth(forKey: cacheKey) {
            return cached
        }
        let depth = try await depthService.estimateDepth(from: image, mode: mode)
        await Spatial3DDepthCache.shared.store(depth: depth, forKey: cacheKey)
        return depth
    }
}
