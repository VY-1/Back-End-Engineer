import AVFoundation
import CoreMedia
import Foundation

struct Spatial3DVideoTrackInfo {
    let track: AVAssetTrack
    let duration: CMTime
    let nominalFrameRate: Float
    let naturalSize: CGSize
}

final class Spatial3DFrameDecoder {
    private let asset: AVAsset

    init(url: URL) {
        self.asset = AVAsset(url: url)
    }

    func loadTrackInfo() async throws -> Spatial3DVideoTrackInfo {
        let tracks = try await asset.loadTracks(withMediaType: .video)
        guard let track = tracks.first else {
            throw Spatial3DConversionError.invalidInput
        }
        let duration = try await asset.load(.duration)
        let frameRate = try await track.load(.nominalFrameRate)
        let size = try await track.load(.naturalSize)
        return Spatial3DVideoTrackInfo(
            track: track,
            duration: duration,
            nominalFrameRate: frameRate,
            naturalSize: size
        )
    }

    func makeReader(
        trimRange: ClosedRange<Double>? = nil
    ) async throws -> (AVAssetReader, AVAssetReaderTrackOutput, Spatial3DVideoTrackInfo) {
        let info = try await loadTrackInfo()
        let reader = try AVAssetReader(asset: asset)
        let outputSettings: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
        ]
        let output = AVAssetReaderTrackOutput(track: info.track, outputSettings: outputSettings)
        output.alwaysCopiesSampleData = false
        guard reader.canAdd(output) else {
            throw Spatial3DConversionError.invalidInput
        }
        reader.add(output)

        if let trimRange {
            let start = CMTime(seconds: trimRange.lowerBound, preferredTimescale: 600)
            let end = CMTime(seconds: trimRange.upperBound, preferredTimescale: 600)
            reader.timeRange = CMTimeRange(start: start, end: end)
        }

        guard reader.startReading() else {
            throw Spatial3DConversionError.exportFailed(reader.error?.localizedDescription ?? "Reader failed.")
        }
        return (reader, output, info)
    }
}
