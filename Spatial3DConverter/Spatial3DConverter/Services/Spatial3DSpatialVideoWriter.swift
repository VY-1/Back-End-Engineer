import AVFoundation
import Foundation

/// Streaming spatial / SBS video writer. MV-HEVC spatial metadata wiring is completed on device in Xcode 26.
final class Spatial3DSpatialVideoWriter {
    private var assetWriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor?
    private var frameIndex: Int64 = 0
    private let outputURL: URL

    init(outputURL: URL) {
        self.outputURL = outputURL
    }

    func startWriting(size: CGSize, fps: Float = 30) throws {
        if FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.removeItem(at: outputURL)
        }

        assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
        let settings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.hevc,
            AVVideoWidthKey: Int(size.width),
            AVVideoHeightKey: Int(size.height)
        ]

        videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: settings)
        videoInput?.expectsMediaDataInRealTime = true

        let attributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA,
            kCVPixelBufferWidthKey as String: Int(size.width),
            kCVPixelBufferHeightKey as String: Int(size.height)
        ]

        if let videoInput {
            pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(
                assetWriterInput: videoInput,
                sourcePixelBufferAttributes: attributes
            )
            assetWriter?.add(videoInput)
        }

        guard assetWriter?.startWriting() == true else {
            throw Spatial3DConversionError.exportFailed("Could not start AVAssetWriter.")
        }
        assetWriter?.startSession(atSourceTime: .zero)
    }

    func append(pixelBuffer: CVPixelBuffer, presentationTime: CMTime) -> Bool {
        guard let videoInput, videoInput.isReadyForMoreMediaData else { return false }
        return pixelBufferAdaptor?.append(pixelBuffer, withPresentationTime: presentationTime) ?? false
    }

    func finishWriting() async throws {
        videoInput?.markAsFinished()
        await assetWriter?.finishWriting()
        if assetWriter?.status == .failed {
            throw Spatial3DConversionError.exportFailed(assetWriter?.error?.localizedDescription ?? "Unknown writer error")
        }
    }
}
