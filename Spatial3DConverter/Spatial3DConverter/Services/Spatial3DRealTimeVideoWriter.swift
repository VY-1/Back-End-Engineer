import AVFoundation
import CoreMedia
import Foundation

/// Streaming writer used by the real-time video pipeline.
final class Spatial3DRealTimeVideoWriter {
    private let writer: Spatial3DSpatialVideoWriter
    private let fps: Float

    init(outputURL: URL, fps: Float = 30) {
        self.writer = Spatial3DSpatialVideoWriter(outputURL: outputURL)
        self.fps = fps
    }

    func start(size: CGSize) throws {
        try writer.startWriting(size: size, fps: fps)
    }

    func append(pixelBuffer: CVPixelBuffer, frameIndex: Int) -> Bool {
        let time = CMTime(value: CMTimeValue(frameIndex), timescale: CMTimeScale(fps))
        return writer.append(pixelBuffer: pixelBuffer, presentationTime: time)
    }

    func finish() async throws {
        try await writer.finishWriting()
    }
}
