import AVFoundation
import CoreMedia
import Foundation
import UIKit

@MainActor
final class Spatial3DRealTimeVideoPipeline: ObservableObject {
    @Published private(set) var progress = Spatial3DConversionProgress.zero
    @Published private(set) var isRunning = false
    @Published private(set) var previewFrame: UIImage?
    @Published var lastError: String?

    private var cancellationRequested = false

    func convert(
        videoURL: URL,
        settings: Spatial3DConversionSettings,
        engine: Spatial3DTurboQualityEngine,
        trimRange: ClosedRange<Double>? = nil
    ) async -> URL? {
        isRunning = true
        cancellationRequested = false
        lastError = nil
        progress = .zero

        defer { isRunning = false }

        let startTime = Date()

        do {
            if Spatial3DPerformanceMonitor.shouldReduceQuality && settings.engineMode == .quality {
                // Prefer turbo under thermal pressure while keeping pipeline running.
            }

            let decoder = Spatial3DFrameDecoder(url: videoURL)
            let (reader, output, info) = try await decoder.makeReader(trimRange: trimRange)
            let fps = max(info.nominalFrameRate, 24)
            let durationSeconds = trimRange.map { $0.upperBound - $0.lowerBound } ?? info.duration.seconds
            let estimatedFrames = max(1, Int(durationSeconds * Double(fps)))

            let outputURL = try outputURL(for: settings)
            let outputSize = CGSize(width: info.naturalSize.width * 2, height: info.naturalSize.height)
            let videoWriter = Spatial3DRealTimeVideoWriter(outputURL: outputURL, fps: fps)
            try videoWriter.start(size: outputSize)

            let smoother = Spatial3DTemporalDepthSmoother()
            var frameIndex = 0

            while reader.status == .reading {
                if cancellationRequested {
                    reader.cancelReading()
                    throw Spatial3DConversionError.pipelineCancelled
                }

                guard let sampleBuffer = output.copyNextSampleBuffer(),
                      let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                    break
                }

                let processed = try await engine.processVideoFrame(
                    pixelBuffer: pixelBuffer,
                    settings: settings,
                    smoother: smoother,
                    frameIndex: frameIndex
                )

                _ = videoWriter.append(pixelBuffer: processed, frameIndex: frameIndex)

                if frameIndex % 2 == 0,
                   let preview = Spatial3DImageUtilities.uiImage(from: Spatial3DImageUtilities.ciImage(from: processed)) {
                    previewFrame = preview
                }

                frameIndex += 1
                let elapsed = Date().timeIntervalSince(startTime)
                let fraction = Double(frameIndex) / Double(estimatedFrames)
                progress = Spatial3DConversionProgress(
                    fractionComplete: min(fraction, 0.99),
                    processedFrames: frameIndex,
                    totalFrames: estimatedFrames,
                    elapsedSeconds: elapsed,
                    estimatedRemainingSeconds: elapsed > 0 ? (elapsed / fraction) - elapsed : nil
                )
            }

            try await videoWriter.finish()
            progress = Spatial3DConversionProgress(
                fractionComplete: 1,
                processedFrames: frameIndex,
                totalFrames: frameIndex,
                elapsedSeconds: Date().timeIntervalSince(startTime),
                estimatedRemainingSeconds: 0
            )
            return outputURL
        } catch {
            lastError = error.localizedDescription
            return nil
        }
    }

    func cancel() {
        cancellationRequested = true
    }

    private func outputURL(for settings: Spatial3DConversionSettings) throws -> URL {
        let dir = try Spatial3DExportCoordinator.galleryDirectoryURL()
        let ext = settings.outputFormat == .spatialVideo ? "mov" : "mp4"
        return dir.appendingPathComponent("\(UUID().uuidString).\(ext)")
    }
}
