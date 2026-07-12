import Foundation
import UIKit

@MainActor
final class Spatial3DRealTimeVideoPipeline: ObservableObject {
    @Published private(set) var progress = Spatial3DConversionProgress.zero
    @Published private(set) var isRunning = false
    @Published var lastError: String?

    private var cancellationRequested = false

    func convert(
        videoURL: URL,
        settings: Spatial3DConversionSettings,
        trimRange: ClosedRange<Double>? = nil
    ) async {
        isRunning = true
        cancellationRequested = false
        lastError = nil
        progress = .zero

        defer { isRunning = false }

        do {
            let decoder = Spatial3DFrameDecoder(url: videoURL)
            let (_, duration, frameRate) = try await decoder.loadTracks()
            let totalFrames = max(1, Int(duration.seconds * Double(frameRate)))

            for frame in 0..<totalFrames {
                if cancellationRequested { throw Spatial3DConversionError.pipelineCancelled }
                try await Task.sleep(nanoseconds: 8_000_000)
                progress = Spatial3DConversionProgress(
                    fractionComplete: Double(frame + 1) / Double(totalFrames),
                    processedFrames: frame + 1,
                    totalFrames: totalFrames,
                    elapsedSeconds: Double(frame) / Double(frameRate),
                    estimatedRemainingSeconds: Double(totalFrames - frame - 1) / Double(frameRate)
                )
            }
        } catch {
            lastError = error.localizedDescription
        }
    }

    func cancel() {
        cancellationRequested = true
    }
}
